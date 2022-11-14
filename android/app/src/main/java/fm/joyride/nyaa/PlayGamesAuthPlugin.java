package fm.joyride.nyaa;

import android.app.Activity;
import android.content.Intent;

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
import com.google.android.gms.games.GamesSignInClient;
import com.google.android.gms.games.PlayGames;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.PlayGamesAuthProvider;

import io.capawesome.capacitorjs.plugins.firebase.authentication.FirebaseAuthenticationHelper;

@CapacitorPlugin(name = "PlayGamesAuth")
public class PlayGamesAuthPlugin extends Plugin {


    @PluginMethod()
    public void signIn(PluginCall call) {
        GoogleSignInClient googleSignInClient = buildGoogleSignInClient(call);
        Intent signInIntent = googleSignInClient.getSignInIntent();
        startActivityForResult(call, signInIntent, "handlePlayGamesAuthProviderSignInActivityResult");
    }

    @ActivityCallback
    private void handlePlayGamesAuthProviderSignInActivityResult(PluginCall call, ActivityResult result) {
        Intent data = result.getData();
        Task<GoogleSignInAccount> task = GoogleSignIn.getSignedInAccountFromIntent(data);
        try {
            GoogleSignInAccount account = task.getResult(ApiException.class);
            String serverAuthCode = account.getServerAuthCode();
            AuthCredential credential = PlayGamesAuthProvider.getCredential(serverAuthCode);
            FirebaseAuth.getInstance()
                    .signInWithCredential(credential)
                    .addOnCompleteListener(
                            getActivity(),
                            task2 -> {
                                if (task2.isSuccessful()) {
                                    JSObject output = new JSObject();
                                    output.put("serverAuthCode", serverAuthCode);
                                    call.resolve(output);
                                } else {
                                    call.reject("Sign in failed");
                                }
                            }
                    );
        } catch (ApiException exception) {
            call.reject("Sign in failed");
        }
    }

    private GoogleSignInClient buildGoogleSignInClient(@Nullable final PluginCall call) {
        GoogleSignInOptions.Builder gsob = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_GAMES_SIGN_IN)
                .requestIdToken(getContext().getString(R.string.default_web_client_id))
                .requestServerAuthCode(getContext().getString(R.string.default_web_client_id))
                .requestEmail();


        return GoogleSignIn.getClient(getActivity(), gsob.build());
    }
}