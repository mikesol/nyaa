package fm.joyride.nyaa;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.getcapacitor.BridgeActivity;
import com.getcapacitor.PluginCall;
import com.google.android.gms.games.PlayGamesSdk;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        registerPlugin(FriendsPlugin.class);
        registerPlugin(PlayGamesAuthPlugin.class);
        PlayGamesSdk.initialize(this);
        super.onCreate(savedInstanceState);
    }
}
