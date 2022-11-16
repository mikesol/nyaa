package fm.joyride.nyaa;

import android.app.Instrumentation;
import android.content.ContentResolver;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.util.Log;

import androidx.activity.result.ActivityResult;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.ActivityCallback;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.google.android.gms.common.images.ImageManager;
import com.google.android.gms.games.AnnotatedData;
import com.google.android.gms.games.GamesSignInClient;
import com.google.android.gms.games.PlayGames;
import com.google.android.gms.games.achievement.Achievement;
import com.google.android.gms.games.achievement.AchievementBuffer;
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

@CapacitorPlugin(name = "PlayGames")
public class PlayGamesPlugin extends Plugin {
    private static final int RC_ACHIEVEMENT_UI = 9003;


    @PluginMethod()
    public void submitScore(PluginCall call) {
        String leaderboardID = call.getString("leaderboardID");
        if (leaderboardID == null) {
            call.reject("No leaderboardID");
            return;
        }
        Integer amount = call.getInt("amount");
        if (amount == null) {
            call.reject("No amount");
            return;
        }
        PlayGames.getLeaderboardsClient(getActivity()).submitScore(leaderboardID, amount);
        call.resolve();
    }

    @PluginMethod
    public void showLeaderboard(PluginCall call) {
        String leaderboardID = call.getString("leaderboardID");
        if (leaderboardID == null) {
            call.reject("No leaderboardID");
            return;
        }
        PlayGames.getLeaderboardsClient(getActivity())
                .getLeaderboardIntent(leaderboardID)
                .addOnSuccessListener(new OnSuccessListener<Intent>() {
                    @Override
                    public void onSuccess(Intent intent) {
                        startActivityForResult(call, intent, "closeLeaderboard");
                    }
                })
                .addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        call.reject("Could not show leaderboard");
                    }
                });
    }

    @PluginMethod()
    public void unlockAchievement(PluginCall call) {
        String achievementID = call.getString("achievementID");
        if (achievementID == null) {
            call.reject("No achievement ID");
            return;
        }
        PlayGames.getAchievementsClient(getActivity()).unlock(achievementID);
        call.resolve();
    }

    @PluginMethod()
    public void incrementAchievement(PluginCall call) {
        String achievementID = call.getString("achievementID");
        if (achievementID == null) {
            call.reject("No achievement ID");
            return;
        }
        Integer amount = call.getInt("amount");
        if (amount == null) {
            call.reject("No amount");
            return;
        }
        PlayGames.getAchievementsClient(getActivity()).increment(achievementID, amount);
        call.resolve();
    }

    @PluginMethod()
    public void getAchievements(PluginCall call) {
        PlayGames.getAchievementsClient(getActivity()).load(false).addOnSuccessListener(task -> {
            AchievementBuffer achievements = task.get();
            int count = achievements.getCount();
            JSObject jsAchievements[] = new JSObject[count];
            for (int i = 0; i < count; i++) {
                Achievement achievement = achievements.get(i);
                JSObject jsAchievement = new JSObject();
                jsAchievement.put("achievementId", achievement.getAchievementId());
                jsAchievement.put("xpValue", achievement.getXpValue());
                jsAchievement.put("type", achievement.getType());
                jsAchievement.put("currentSteps", achievement.getCurrentSteps());
                jsAchievement.put("formattedCurrentSteps", achievement.getFormattedCurrentSteps());
                jsAchievement.put("description", achievement.getDescription());
                jsAchievement.put("totalSteps", achievement.getTotalSteps());
                jsAchievement.put("formattedTotalSteps", achievement.getFormattedTotalSteps());
                jsAchievement.put("lastUpdatedTimestamp", achievement.getLastUpdatedTimestamp());
                jsAchievement.put("name", achievement.getName());
                jsAchievement.put("state", achievement.getState());
                // todo - add uris like revealed image URI? do we need these?
                jsAchievements[i] = jsAchievement;
            }
            JSObject res = new JSObject();
            res.put("achievements", jsAchievements);
            call.resolve(res);
        }).addOnFailureListener(error -> {
            call.reject("Could not load achievements");
        });
    }

    @PluginMethod()
    public void showAchievements(PluginCall call) {
        PlayGames.getAchievementsClient(getActivity())
                .getAchievementsIntent()
                .addOnSuccessListener(new OnSuccessListener<Intent>() {
                    @Override
                    public void onSuccess(Intent intent) {
                        startActivityForResult(call, intent, "closedAchievements");
                    }
                })
                .addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        call.reject("Could not show achievements");
                    }
                });
    }

    @ActivityCallback
    private void closedAchievements(PluginCall call, ActivityResult result) {
        if (call == null) {
            call.resolve();
            return;
        }
    }

    @ActivityCallback
    private void closeLeaderboard(PluginCall call, ActivityResult result) {
        if (call == null) {
            call.resolve();
            return;
        }
    }

}