package com.keepant.sparring

import android.os.Bundle
import android.widget.Toast
import com.midtrans.sdk.corekit.callback.TransactionFinishedCallback
import com.midtrans.sdk.corekit.core.MidtransSDK
import com.midtrans.sdk.corekit.core.themes.CustomColorTheme
import com.midtrans.sdk.corekit.models.snap.Transaction
import com.midtrans.sdk.corekit.models.snap.TransactionResult
import com.midtrans.sdk.uikit.BuildConfig
import com.midtrans.sdk.uikit.SdkUIFlowBuilder
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity(), TransactionFinishedCallback {
    private val clientKey = "SB-Mid-client-9aJKBTOwDXlm0IkM"
    private val baseUrl = "https://sparring-midtrans.herokuapp.com/index.php/"

    companion object {
        const val CHANNEL = "com.keepant.sparring"
        const val KEY_NATIVE = "showPaymentGateway"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, CHANNEL).setMethodCallHandler{ call, result ->
            if(call.method == KEY_NATIVE) {
                val name = (""+call.argument("name"))
                val price = (""+call.argument("price")).toInt()
                val qty = (""+call.argument("qty")).toInt()

                initMidtransSdk()

                MidtransSDK.getInstance().transactionRequest = DataUser.transactionRequest(
                        "1",
                        price,
                        qty,
                        name
                )

                MidtransSDK.getInstance().startPaymentUiFlow(this)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun initMidtransSdk() {
        SdkUIFlowBuilder.init()
                .setContext(this)
                .setMerchantBaseUrl(baseUrl)
                .setClientKey(clientKey)
                .setTransactionFinishedCallback(this)
                .enableLog(true)
                .setColorTheme(CustomColorTheme("#FFE51255", "#B61548", "#FFE51255"))
                .buildSDK()
    }


    override fun onTransactionFinished(result: TransactionResult) {
        if(result.response != null) {
             when(result.status) {
                 TransactionResult.STATUS_SUCCESS -> Toast.makeText(this, "Success ID: "+ result.response.transactionId, Toast.LENGTH_SHORT)
                 TransactionResult.STATUS_PENDING -> Toast.makeText(this, "Pending ID: "+ result.response.transactionId, Toast.LENGTH_SHORT)
                 TransactionResult.STATUS_FAILED -> Toast.makeText(this, "Failed ID: "+ result.response.transactionId, Toast.LENGTH_SHORT)
             }
            result.response.validationMessages
        } else if(result.isTransactionCanceled) {
            Toast.makeText(this, "Cancelled", Toast.LENGTH_LONG)
        } else {
            if (result.status.equals(TransactionResult.STATUS_INVALID)) {
                Toast.makeText(this, "Invalid", Toast.LENGTH_LONG)
            } else {
                Toast.makeText(this, "Finished with failure", Toast.LENGTH_LONG)
            }
        }
    }
}
