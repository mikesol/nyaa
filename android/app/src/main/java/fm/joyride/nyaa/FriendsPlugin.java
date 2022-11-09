package fm.joyride.nyaa;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.content.IntentSender;
import android.graphics.Bitmap;
import android.net.Uri;
import android.provider.MediaStore;
import android.util.Base64;

import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.IntentSenderRequest;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;

import com.getcapacitor.Bridge;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.google.android.gms.games.AnnotatedData;
import com.google.android.gms.games.FriendsResolutionRequiredException;
import com.google.android.gms.games.PlayGames;
import com.google.android.gms.games.Player;
import com.google.android.gms.games.PlayerBuffer;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;

import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;


@CapacitorPlugin(name = "Friends")
public class FriendsPlugin extends Plugin {

    public static int SHOW_SHARING_FRIENDS_CONSENT = 42;
    private static int INITIAL_FRIENDS_TO_LOAD = 20;
    private static String GOOGLE_PLAY_GAMES = "com.google.android.play.games";
    // uggggggghhhhh
    private ActivityResultLauncher<IntentSenderRequest> launcher = null;

    @PluginMethod()
    public void sendFriendRequest(PluginCall call) {

        Intent launchIntent = getActivity().getPackageManager().getLaunchIntentForPackage(GOOGLE_PLAY_GAMES);
        try {
            getActivity().startActivity(launchIntent);
            call.resolve();
        } catch (ActivityNotFoundException e) {
            call.reject("Play Games not found", "PLAY_GAMES_NOT_FOUND");
        }
    }

    @PluginMethod()
    public void getFriends(PluginCall call) {
        PlayGames.getPlayersClient(getActivity())
                .loadFriends(INITIAL_FRIENDS_TO_LOAD, /* forceReload= */ false)
                .addOnSuccessListener(
                        new OnSuccessListener<AnnotatedData<PlayerBuffer>>() {
                            @Override
                            public void onSuccess(AnnotatedData<PlayerBuffer> data) {
                                PlayerBuffer playerBuffer = data.get();
                                int nPlayers = playerBuffer.getCount();
                                JSObject[] players = new JSObject[nPlayers];
                                for (var i = 0; i < nPlayers; i++) {
                                    JSObject jsPlayer = new JSObject();
                                    Player player = playerBuffer.get(i);
                                    String id = player.getPlayerId();
                                    jsPlayer.put("playGamesID", id);
                                    String displayName = player.getDisplayName();
                                    jsPlayer.put("displayName", displayName);
                                    String title = player.getTitle();
                                    jsPlayer.put("alias", title);
                                    Uri imageUri = player.getIconImageUri();
                                    try {
                                        Bitmap bitmap = MediaStore.Images.Media.getBitmap(FriendsPlugin.this.getActivity().getContentResolver(), imageUri);
                                        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
                                        bitmap.compress(Bitmap.CompressFormat.JPEG, 50, byteArrayOutputStream);
                                        byte[] byteArray = byteArrayOutputStream .toByteArray();
                                        String encoded = Base64.encodeToString(byteArray, Base64.DEFAULT);
                                        jsPlayer.put("avatar", encoded);
                                    } catch (FileNotFoundException e) {
                                        jsPlayer.put("avatar", null);
                                    } catch (IOException e) {
                                        jsPlayer.put("avatar", null);
                                    }
                                    players[i] = jsPlayer;
                                }
                                JSObject res = new JSObject();
                                res.put("friends", players);
                                call.resolve(res);
                            }
                        }).

                addOnFailureListener(
                        new OnFailureListener() {
                            @Override
                            public void onFailure(Exception exception) {
                                if (exception instanceof FriendsResolutionRequiredException) {
                                    PendingIntent pendingIntent = ((FriendsResolutionRequiredException) exception).getResolution();
                                    launcher = getActivity().registerForActivityResult(new ActivityResultContracts.StartIntentSenderForResult(), new ActivityResultCallback<ActivityResult>() {
                                        @Override
                                        public void onActivityResult(ActivityResult activityResult) {
                                            if (launcher != null) {
                                                launcher.unregister();
                                            }
                                            if (activityResult.getResultCode() == Activity.RESULT_OK) {
                                                FriendsPlugin.this.getFriends(call);
                                            } else {
                                                call.reject("Denied getting friends", "FRIEND_REQUEST_WAS_DENIED");
                                            }
                                        }
                                    });
                                    launcher.launch(new IntentSenderRequest.Builder(pendingIntent).build());
                                }
                            }
                        });
    }
}
