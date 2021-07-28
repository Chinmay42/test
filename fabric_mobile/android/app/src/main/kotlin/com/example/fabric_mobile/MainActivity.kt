package com.example.fabric_mobile

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.os.Bundle
import android.util.Log
import android.widget.Switch


import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.BinaryMessenger
import androidx.core.content.ContextCompat.getSystemService

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    private var result: MethodChannel.Result? = null
    private val INTENT_ACTION = "com.example.biometricscanner.Scanner"
    private val INTENT_ACTION_VERIFY = "com.example.biometricscanner.Verify"
    private val SCANNER_REQ_CODE = 11;
    private val VERIFICATION_CODE = 12;


    private val callHandler = MethodChannel.MethodCallHandler { call, result ->
        this.result = result

        when (call.method) {
            "launchApp2"->  launchApp2()
            "launchAppForVerification" ->
            {
                val path:String? = (call.argument("path"));
                launchAppForVerification(path!!);
            }

        }



    }



    override fun onCreate(savedInstanceState: Bundle?)
    {
        super.onCreate(savedInstanceState)

        MethodChannel(
                getBinaryMessenger(),
                "get.data/Scanner")
                .setMethodCallHandler(callHandler)
    }

    fun getBinaryMessenger(): BinaryMessenger {
        return flutterEngine!!.getDartExecutor().getBinaryMessenger()
    }
    override fun onResume()
    {
        super.onResume()
    }
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?)
    {
        super.onActivityResult(requestCode, resultCode, data);
        when(resultCode)
        {
            SCANNER_REQ_CODE ->
            {
                val bundle = data?.extras

                val success = (bundle?.getBoolean("success"))
                if(success!!)
                {
                    val path = bundle?.getString("path")
                    result?.success(path)
                }else
                {
                    val errorCode = (bundle?.getInt("code"))
                    val msg = (bundle?.getString("msg"))
                    result?.error(errorCode.toString(), msg.toString(),msg);
                }


            }
            VERIFICATION_CODE ->
            {
                val bundle = data?.extras
                val success = (bundle?.getBoolean("success"))

                if(success!!)
                {
                    result?.success(true);
                }else
                {
                    val errorCode = (bundle?.getInt("code"))
                    val msg = (bundle?.getString("msg"))
                    result?.error(errorCode.toString(), msg.toString(),msg);
                }

            }

        }
    }

    @SuppressLint("NewApi")
    private fun launchApp2() {
             Log.e("launchApp2","launchApp2");
     //   print('launch app');
        val sendIntent = Intent()
        sendIntent.action = INTENT_ACTION
        sendIntent.flags = Intent.FLAG_ACTIVITY_SINGLE_TOP
        if (sendIntent.resolveActivity(packageManager) != null) {
            startActivityForResult(sendIntent, SCANNER_REQ_CODE)
        }

    }


    @SuppressLint("NewApi")
    private fun launchAppForVerification(filePath:String) {

        Log.e("launchAppForVerification","launchAppForVerification $filePath" );
        val sendIntent = Intent()
        sendIntent.action = INTENT_ACTION_VERIFY

        var bundle =  Bundle();
        bundle.putString("fingerfile",filePath);
        bundle.putBoolean("isForVerfication",true);
        sendIntent.putExtras(bundle)
        sendIntent.flags = Intent.FLAG_ACTIVITY_SINGLE_TOP
        if (sendIntent.resolveActivity(packageManager) != null) {
            startActivityForResult(sendIntent, VERIFICATION_CODE)
        }

    }
}