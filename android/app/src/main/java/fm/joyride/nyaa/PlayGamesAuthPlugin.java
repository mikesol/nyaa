package fm.joyride.nyaa;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.util.Log;

import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.ActivityCallback;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.images.ImageManager;
import com.google.android.gms.games.GamesSignInClient;
import com.google.android.gms.games.PlayGames;
import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.PlayGamesAuthProvider;
import com.google.firebase.auth.UserInfo;
import com.google.firebase.auth.UserProfileChangeRequest;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageMetadata;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.UploadTask;

import java.io.ByteArrayOutputStream;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

@CapacitorPlugin(name = "PlayGamesAuth")
public class PlayGamesAuthPlugin extends Plugin {

    private Retrofit retrofit = new Retrofit.Builder()
            .baseUrl("https://us-central1-nyaa-game.cloudfunctions.net/")
            .addConverterFactory(GsonConverterFactory.create())
            .build();

    PlayGamesAuthService playGamesAuthService = retrofit.create(PlayGamesAuthService.class);

    @PluginMethod()
    public void signOut(PluginCall call) {
        FirebaseAuth.getInstance().signOut();
        call.resolve();
    }



    private void finishAuthFlow(UserProfileChangeRequest profileUpdates, String bodyResult, PluginCall call) {

        FirebaseAuth.getInstance()
                .getCurrentUser().updateProfile(profileUpdates)
                .addOnCompleteListener(new OnCompleteListener<Void>() {
                    @Override
                    public void onComplete(@NonNull Task<Void> task) {
                        // always return!
                        JSObject output = new JSObject();
                        output.put("result", bodyResult);
                        call.resolve(output);
                    }
                });
    }

    private void doSignInFlowAfterPlayGamesAuth(String playerId, String displayName, Uri imageUri, PluginCall call) {
        GamesSignInClient gamesSignInClient = PlayGames.getGamesSignInClient(getActivity());
        // as it's going to a server, use the server client id
        gamesSignInClient
                .requestServerSideAccess(getActivity().getResources().getString(R.string.default_web_client_id), /* forceRefreshToken= */ false)
                .addOnCompleteListener( task -> {
                    if (task.isSuccessful()) {
                        String serverAuthToken = task.getResult();
                        //call.reject("hack");
                        //if (1==1) {return;}
                        Log.d("Nyaa", "cred1");
                        Log.d("Nyaa", serverAuthToken);

                        Call<PGAuthResult> resultCall = playGamesAuthService.pgAuth(new PGAuthRequest(serverAuthToken, playerId));
                        resultCall.enqueue(new Callback<PGAuthResult>() {
                            @Override
                            public void onResponse(Call<PGAuthResult> res, Response<PGAuthResult> response) {
                                if (!response.isSuccessful()) {
                                    Log.e("Nyaa",  "error with code: "+response.code()+" and body: "+response.errorBody());
                                    call.reject("Rejecting call");
                                    return;
                                }
                                String bodyResult = response.body().result;
                                FirebaseAuth.getInstance().signInWithCustomToken(bodyResult)
                                        .addOnCompleteListener(getActivity(), task -> {
                                            AuthResult authResult = task.getResult();
                                            List<? extends UserInfo> userInfoList = authResult.getUser().getProviderData();
                                            boolean hasPG = false;
                                            for (int i = 0; i < userInfoList.size(); i++) {
                                                // Log.d("Nyaa", userInfoList.get(i).getProviderId());
                                                String pid = userInfoList.get(i).getProviderId();
                                                if (pid.equals("playgames.google.com")) {
                                                    hasPG = true;
                                                    break;
                                                }
                                            }
                                            if (hasPG) {
                                                JSObject output = new JSObject();
                                                output.put("result", bodyResult);
                                                call.resolve(output);
                                                return;
                                            }
                                            // otherwise, do linking
                                            // for some reason this requires the default_web_client_id instead of the server_client_id
                                            gamesSignInClient
                                                    .requestServerSideAccess(getActivity().getResources().getString(R.string.default_web_client_id), /* forceRefreshToken= */ false)
                                                    .addOnCompleteListener( task2 -> {
                                                        String serverAuthToken2 = task2.getResult();
                                                        AuthCredential credential = PlayGamesAuthProvider.getCredential(serverAuthToken2);
                                                        Log.d("Nyaa", "cred2");
                                                        Log.d("Nyaa", serverAuthToken2);
                                                        FirebaseAuth.getInstance()
                                                                .getCurrentUser()
                                                                .linkWithCredential(credential)
                                                                .addOnFailureListener(error -> {
                                                                    Log.e("Nyaa", "err", error);
                                                                })
                                                                .addOnCompleteListener(
                                                                        getActivity(),
                                                                        task3 -> {
                                                                            if (task3.isSuccessful()) {
                                                                                // do change request
                                                                                final UserProfileChangeRequest.Builder profileUpdatesBuilder = new UserProfileChangeRequest.Builder()
                                                                                        .setDisplayName(displayName);
                                                                                if (imageUri != null) {
                                                                                    StorageReference storageRef = FirebaseStorage.getInstance().getReference();
                                                                                    StorageReference profileImageRef = storageRef.child("nyaaProfileImages/" + FirebaseAuth.getInstance().getCurrentUser().getUid());
                                                                                    ContentResolver cR = getActivity().getContentResolver();
                                                                                    String mimeType = cR.getType(imageUri);
                                                                                    ////
                                                                                    ImageManager imageManager = ImageManager.create(getActivity());
                                                                                    imageManager.loadImage(new ImageManager.OnImageLoadedListener() {
                                                                                        @Override
                                                                                        public void onImageLoaded(@NonNull Uri uri, @Nullable Drawable drawable, boolean b) {
                                                                                            if (drawable instanceof BitmapDrawable) {
                                                                                                BitmapDrawable bmDrawable = (BitmapDrawable) drawable;
                                                                                                StorageMetadata metadata = new StorageMetadata.Builder()
                                                                                                        .setContentType("image/png")
                                                                                                        .build();
                                                                                                ByteArrayOutputStream bos = new ByteArrayOutputStream();

                                                                                                bmDrawable.getBitmap().compress(Bitmap.CompressFormat.PNG,
                                                                                                        80,
                                                                                                        bos);

                                                                                                UploadTask uploadTask = profileImageRef.putBytes(bos.toByteArray(), metadata);
                                                                                                uploadTask.continueWithTask(new Continuation<UploadTask.TaskSnapshot, Task<Uri>>() {
                                                                                                    @Override
                                                                                                    public Task<Uri> then(@NonNull Task<UploadTask.TaskSnapshot> task) throws Exception {
                                                                                                        if (!task.isSuccessful()) {
                                                                                                            throw task.getException();
                                                                                                        }

                                                                                                        // Continue with the task to get the download URL
                                                                                                        return profileImageRef.getDownloadUrl();
                                                                                                    }
                                                                                                }).addOnFailureListener(getActivity(), uploadError -> {
                                                                                                    // oh well, we tried...
                                                                                                    PlayGamesAuthPlugin.this.finishAuthFlow(profileUpdatesBuilder.build(), bodyResult, call);
                                                                                                }).addOnCompleteListener(getActivity(), uploadSuccess -> {
                                                                                                    PlayGamesAuthPlugin.this.finishAuthFlow(profileUpdatesBuilder.setPhotoUri(uploadSuccess.getResult()).build(), bodyResult, call);
                                                                                                });
                                                                                            } else {
                                                                                                PlayGamesAuthPlugin.this.finishAuthFlow(profileUpdatesBuilder.build(), bodyResult, call);
                                                                                            }

                                                                                        }
                                                                                    }, imageUri);
                                                                                    return;
                                                                                }
                                                                                // no image? no problem!

                                                                                UserProfileChangeRequest profileUpdates = profileUpdatesBuilder.build();
                                                                                FirebaseAuth.getInstance()
                                                                                        .getCurrentUser().updateProfile(profileUpdates)
                                                                                        .addOnCompleteListener(new OnCompleteListener<Void>() {
                                                                                            @Override
                                                                                            public void onComplete(@NonNull Task<Void> task) {
                                                                                                // always return!
                                                                                                JSObject output = new JSObject();
                                                                                                output.put("result", bodyResult);
                                                                                                call.resolve(output);
                                                                                            }
                                                                                        });

                                                                            } else {
                                                                                call.reject("Sign in failed");
                                                                            }
                                                                        }
                                                                );
                                                    });
                                        })
                                        .addOnFailureListener(getActivity(), error -> {
                                            call.reject("Could not sign in with custom token");
                                        });
                            }

                            @Override
                            public void onFailure(Call<PGAuthResult> call, Throwable t) {

                            }
                        });
                    } else {
                       call.reject("Failed to retrieve auth code");
                    }
                });

    }

    @PluginMethod()
    public void signIn(PluginCall call) {
        GamesSignInClient gamesSignInClient = PlayGames.getGamesSignInClient(getActivity());

            gamesSignInClient.isAuthenticated().addOnCompleteListener(isAuthenticatedTask -> {
                boolean isAuthenticated =
                        (isAuthenticatedTask.isSuccessful() &&
                                isAuthenticatedTask.getResult().isAuthenticated());

                if (isAuthenticated) {
                    PlayGames.getPlayersClient(getActivity()).getCurrentPlayer().addOnCompleteListener(mTask -> {
                                String playerId = mTask.getResult().getPlayerId();
                                String displayName = mTask.getResult().getDisplayName();
                                Uri imageUri = mTask.getResult().getIconImageUri();
                                PlayGamesAuthPlugin.this.doSignInFlowAfterPlayGamesAuth(playerId, displayName, imageUri, call);
                            }
                    );
                } else {
                    gamesSignInClient.signIn()
                            .addOnCompleteListener(getActivity(), signInTask -> {
                                PlayGames.getPlayersClient(getActivity()).getCurrentPlayer().addOnCompleteListener(mTask -> {
                                            String pid = mTask.getResult().getPlayerId();
                                            String displayName = mTask.getResult().getDisplayName();
                                            Uri imageUri = mTask.getResult().getIconImageUri();
                                            PlayGamesAuthPlugin.this.doSignInFlowAfterPlayGamesAuth(pid, displayName, imageUri, call);
                                        }
                                );
                            })
                            .addOnFailureListener(getActivity(), signInError -> {
                                call.reject("Could not sign into play games");
                            });
                }
            });
    }
}