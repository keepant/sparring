package com.keepant.sparring

import com.midtrans.sdk.corekit.core.TransactionRequest
import com.midtrans.sdk.corekit.models.BankType
import com.midtrans.sdk.corekit.models.CustomerDetails
import com.midtrans.sdk.corekit.models.ItemDetails
import com.midtrans.sdk.corekit.models.snap.CreditCard

object DataUser {
    var NAME = "sparring"
    var PHONE = "087836900013"
    var EMAIL = "sparringdev@gmail.com"

    private fun userDetails() : CustomerDetails {
        var cd = CustomerDetails()
        cd.firstName = NAME
        cd.email = EMAIL
        cd.phone = PHONE

        return cd
    }

    fun transactionRequest(orderID: String, id: String?, price: Int, qty: Int, name: String?) : TransactionRequest {
        val totalPrice = price * qty;
        val request = TransactionRequest(orderID, totalPrice.toDouble())
        request.customerDetails = userDetails()

        val details = ItemDetails(id, price.toDouble(), qty, name)
        val itemDetails = ArrayList<ItemDetails>()
        itemDetails.add(details)
        request.itemDetails  = itemDetails

        val creditCard = CreditCard()
        creditCard.isSaveCard = false
        creditCard.authentication = CreditCard.AUTHENTICATION_TYPE_RBA
        creditCard.bank = BankType.MANDIRI
        request.creditCard = creditCard

        return request
    }
}