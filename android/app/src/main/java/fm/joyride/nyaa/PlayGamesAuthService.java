package fm.joyride.nyaa;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.POST;

public interface PlayGamesAuthService {
    @POST("pgAuth")
    Call<PGAuthResult> pgAuth(@Body PGAuthRequest request);
}
