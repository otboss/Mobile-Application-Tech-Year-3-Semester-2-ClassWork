package com.bignerdranch.android.beatbox;


import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuItem;

public abstract class SingleFragmentActivity extends AppCompatActivity {
    protected abstract Fragment createFragment();

    private final static int DEFAULT_THEME  = -1;
    private final static int LIGHT_THEME  = 0;
    private final static int DARK_THEME  = 1;
    public static int CURR_THEME = DEFAULT_THEME;
    protected int getLayoutResId() {
        return R.layout.activity_fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(getLayoutResId());
        FragmentManager manager = getSupportFragmentManager();
        Fragment fragment = manager.findFragmentById(R.id.fragment_container);

        if (fragment == null) {
            fragment = createFragment();
            manager.beginTransaction()
                .add(R.id.fragment_container, fragment)
                .commit();
        }

//        switch (CURR_THEME){
//            case DEFAULT_THEME:
//                setTheme(R.style.AppTheme);
//                break;
//            case LIGHT_THEME:
//                setTheme(R.style.LightAppTheme);
//                break;
//            case DARK_THEME:
//                setTheme(R.style.DarkAppTheme);
//                break;
//            default:
//                setTheme(R.style.AppTheme);
//                break;
//        }
//        setContentView(R.layout.fragment_beat_box);
    }

    /*
     * Displays the menu icon in the app bar
     * */
    @Override
    public boolean onCreateOptionsMenu(Menu menu){
        //inflator.inflate(R.menu.menu, menu);
        getMenuInflater().inflate(R.menu.menu, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()){
            case R.id.defaultTheme:
                //CURR_THEME = DEFAULT_THEME;
                setTheme(R.style.AppTheme);
                break;
            case R.id.lightTheme:

                //CURR_THEME = LIGHT_THEME;
                setTheme(R.style.LightAppTheme);
                break;
            case R.id.darkTheme:
                //CURR_THEME = DARK_THEME;
                setTheme(R.style.DarkAppTheme);
                break;
            default:
                //CURR_THEME = DEFAULT_THEME;
                setTheme(R.style.AppTheme);
                break;
        }


//        finish();
//        Intent intent = new Intent(this, SingleFragmentActivity.class);
//        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
//        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//        startActivity(intent);
//        setContentView(R.layout.fragment_beat_box);
        return super.onOptionsItemSelected(item);
    }
}
