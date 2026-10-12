// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

function newAmount(string value) returns Amount => {value, currency: "USD"};

function newPayout(string payoutId) returns Payout => {
    payoutId,
    payoutStatus: "SUCCEEDED",
    payoutStatusDescription: "Payout completed successfully",
    payoutDate: "2026-03-16T06:00:00.000Z",
    amount: newAmount("812.69"),
    totalAmount: newAmount("812.69"),
    payoutInstrument: {
        instrumentType: "BANK",
        accountLastFourDigits: "4321",
        nickname: "Business checking"
    },
    transactionCount: 24,
    bankReference: "BANKREF-20260316-01"
};

function newOrderEarning(string orderId) returns OrderEarning => {
    orderId,
    orderCreationDate: "2026-03-10T09:15:00.000Z",
    orderLastModifiedDate: "2026-03-12T11:30:00.000Z",
    orderEarningsSummary: {
        grossAmount: newAmount("150.00"),
        orderEarnings: newAmount("128.50"),
        refunds: newAmount("0.00")
    },
    buyer: {username: "buyer_jane"}
};

listener http:Listener ep0 = new (9090);

service / on ep0 {
    resource function get 'transaction(@http:Header {name: "X-EBAY-C-MARKETPLACE-ID"} MarketplaceIdEnum xEBAYCMARKETPLACEID, int? 'limit, int? offset, string[]? filter, string[]? sort) returns Transactions|http:NoContent|ErrorBadRequest|ErrorUnauthorized|ErrorForbidden|ErrorInternalServerError {
        Transactions result = {
            href: "https://apiz.ebay.com/sell/finances/v1/transaction?limit=20&offset=0",
            total: 2,
            offset: 0,
            'limit: 20,
            transactions: [
                {
                    transactionId: "01-12345-67890",
                    transactionType: "SALE",
                    transactionStatus: "PAYOUT",
                    transactionDate: "2026-03-14T10:22:31.000Z",
                    salesRecordReference: "1042",
                    bookingEntry: "CREDIT",
                    orderId: "27-12345-67890",
                    payoutId: "5000012345",
                    amount: newAmount("125.40"),
                    buyer: {username: "buyer_jane"}
                },
                {
                    transactionId: "01-12345-67891",
                    transactionType: "NON_SALE_CHARGE",
                    transactionStatus: "COMPLETED",
                    transactionDate: "2026-03-15T08:05:12.000Z",
                    salesRecordReference: "0",
                    bookingEntry: "DEBIT",
                    feeType: "AD_FEE",
                    amount: newAmount("4.75")
                }
            ]
        };
        return result;
    }

    # List billing activities
    #
    # + acceptLanguage - This header indicates the natural language and locale preferred by the user for the response.<br><br>For more information, see the <b>Accept-Language</b> header in <a href="/develop/api/sell/request_headers" target="_blank ">Request Headers</a> and <a href="/develop/api/sell/request_headers#marketplace-id-values"  target="_blank">Marketplace ID values</a>. If not provided, defaults to <code>en-US</code>
    # + filter - This required field specifies which results to return in the response. Only one of the following four filter values must be used. A user can either retrieve all billing activity within a date range, or they can retrieve billing activity related to a specific eBay order, eBay listing, or they can retrieve information on a specific billing activity.<br /><ul><li><b>activityId</b>: If this filter is used, only information on a specific billing activity is returned. The <a href="/develop/api/sell/finances_api#sell-finances_api-billing_activity-getbillingactivities.billingactivitylineitem.billingtransactionid">billingTransactionId</a> returned in the response can be used as the <b>activityId</b>.</li><li><b>listingId</b>: If this filter is used, only billing activity associated with the specified listing is returned.</li><li><b>orderId</b>: If this filter is used, only billing activity associated with the specified order is returned.</li><li><b>transactionDate</b>: If a date range filter is used, only billing activity that occurred within the specified date range is returned. The starting date cannot be set back further than 120 days in the past. Use UTC date values in the following order: <code>[<em>start</em>..<em>end</em>]</code></li></ul><br /><b>Examples</b><br /><br />IDs:<br /> <code>filter=activityID:{12**56}</code><br /><br />Date range:<br />  <code>filter=transactionDate:[2025-10-01T00:00:00Z..2025-10-31T23:59:59Z]</code>
    # + 'limit - Sets the maximum number of records to return per page of data.<br><p>Use this parameter in conjunction with the <b>offset</b> parameter to control the pagination of the output. For example, with offset set to <code>20</code> and limit set to <code>10</code>, the call retrieves entries 21 through 30 from the result set.</p><p>Although this field is optional, if omitted the default value of <code>100</code> is used.</p><br> <b>Minimum:</b> <code>1</code><br><b>Maximum:</b> <code>200</code><br><b>Default:</b> <code>100</code>
    # + offset - Specifies the number of records to skip in the result set. This is used with the <code>limit</code> field to control the pagination of the output. For example:<br><ul><li>If <b>offset</b> is <code>0</code> and <b>limit</b> is <code>10</code>, the method will retrieve records 1-10 from the list of records returned</li><li>If <b>offset</b> is <code>10</code> and <b>limit</b> is <code>10</code>, the method will retrieve records 11-20 from the list of records returned.</li></ul><p>If this parameter is not set, its value defaults to <code>0</code> which returns the first page of records.</p><p><span class="tablenote"><span style="color:#004680"><strong>Note: </strong>This feature employs a zero-based list, where the first activity in the list has an offset of 0.</span></p><p><b>Default:</b> <code>0</code> (zero, returns the first page)</p>
    # + sort - By default, transactions that match the input criteria are sorted in descending order according to the transaction date (most recent transactions returned first).<br><br>To view transactions in ascending order instead (oldest transactions first), include the <b>sort</b> query parameter and set its value to <code>sort=transactionDate</code>. For example (ascending order):<br><br><code>filter=transactionDate:[2025-11-01T00:00:01.000Z..2025-11-12T00:00:01.000Z]&sort=transactionDate</code><br><br>Transactions can only be sorted according to transaction date. If omitted, defaults to descending order (most recent transactions returned first)
    # + return - returns can be any of following types 
    # http:Ok (OK)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function get billing_activity(@http:Header {name: "Accept-Language"} string? acceptLanguage, string? filter, string? 'limit, string? offset, string? sort) returns BillingActivityResponse|http:BadRequest|http:InternalServerError {
        BillingActivityResponse result = {
            total: 1,
            offset: 0,
            'limit: 20,
            count: 1,
            billingActivities: [
                {
                    billingTransactionId: "BT-7781234",
                    billingTransactionDate: "2026-03-01T00:00:00.000Z",
                    bookingEntry: "DEBIT",
                    feeType: "FINAL_VALUE_FEE",
                    feeTypeDescription: "Final value fee",
                    orderId: "27-12345-67890",
                    listingId: "110554321987",
                    amount: newAmount("12.35")
                }
            ]
        };
        return result;
    }

    # List order earnings
    #
    # + xEBAYCMARKETPLACEID - This header identifies the seller's eBay marketplace.<br><br>See <a href="/develop/api/sell/request_headers#marketplace-id-values" target="_blank ">Request Headers</a> for the marketplace ID values.<br><br><span class="tablenote"><b>Note:</b> If a marketplace ID value is not provided, the default value of <code>EBAY_US</code> is used.</span>
    # + 'limit - This parameter configures the number of orders to return per page of the result set. Use this parameter in conjunction with the <b>offset</b> parameter to control the pagination of the output. <br><br> For example, if <b>offset</b> is set to <code>10</code> and <b>limit</b> is set to <code>10</code>, the method retrieves orders 11 thru 20 from the result set. <br><br> <span class="tablenote"><strong>Note:</strong> This feature employs a zero-based list, where the first page in the results set has an offset value of <code>0</code>. </span><br> <b>Maximum:</b> <code>200</code> <br> <b>Default:</b> <code>20</code>
    # + offset - This parameter can be used to specify the number of records to skip before returning results. This parameter is commonly used with the <code>limit</code> parameter to retrieve the next page of results.<br><br><b>Maximum:</b> 10,000<br><b>Default:</b> 0
    # + filter - This parameter can be used to filter orders created within a specified date range. The filter uses the <code>orderCreationDate</code> field, which works similarly to the <code>transactionDate</code> filter used by the Transactions API. Currently, <code>orderCreationDate</code> is the only supported filter value. <p><span class="tablenote"><span style="color:#004680"><strong>Note: </strong>All dates must be input using UTC format (<code>YYYY-MM-DDTHH:MM:SS.SSSZ</code>) and should be adjusted accordingly for the local timezone of the user.</span></p><p><b>Default</b>: If no value is specified, results from the past year will be returned.</p>
    # + sort - Sort order for a collection of resources. Available value: orderCreationDate For implementation help, refer to eBay API documentation at https://developer.ebay.com/api-docs/sell/finances/types/sqa:SortField
    # + return - returns can be any of following types 
    # http:Ok (The retrieved order earnings)
    # http:BadRequest (Bad Request)
    # http:Unauthorized (Unauthorized)
    # http:Forbidden (Forbidden)
    # http:InternalServerError (Internal Server Error)
    resource function get order_earnings(@http:Header {name: "X-EBAY-C-MARKETPLACE-ID"} MarketplaceIdEnum xEBAYCMARKETPLACEID, int? 'limit, int? offset, string[]? filter, string[]? sort) returns OrderEarnings|ErrorBadRequest|ErrorUnauthorized|ErrorForbidden|ErrorInternalServerError {
        OrderEarnings result = {
            href: "https://apiz.ebay.com/sell/finances/v1/order_earnings?limit=20&offset=0",
            total: 1,
            offset: 0,
            'limit: 20,
            orders: [newOrderEarning("27-12345-67890")]
        };
        return result;
    }

    # Get order earnings by order ID
    #
    # + xEBAYCMARKETPLACEID - This header identifies the seller's eBay marketplace.<br><br>See <a href="/develop/api/sell/request_headers#marketplace-id-values " target="_blank ">Request Headers</a> for the marketplace ID values.<br><br><span class="tablenote"><b>Note:</b> If a marketplace ID value is not provided, the default value of <code>EBAY_US</code> is used.</span>
    # + orderId - This path parameter identifies the specific order for which earnings information is requested
    # + return - returns can be any of following types 
    # http:Ok (The retrieved order earning)
    # http:BadRequest (Bad Request)
    # http:Unauthorized (Unauthorized)
    # http:Forbidden (Forbidden)
    # http:NotFound (Not found)
    # http:InternalServerError (Internal Server Error)
    resource function get order_earnings/[string orderId](@http:Header {name: "X-EBAY-C-MARKETPLACE-ID"} MarketplaceIdEnum xEBAYCMARKETPLACEID) returns OrderEarning|ErrorBadRequest|ErrorUnauthorized|ErrorForbidden|ErrorNotFound|ErrorInternalServerError {
        OrderEarning result = newOrderEarning(orderId);
        return result;
    }

    # Get order earnings summary
    #
    # + xEBAYCMARKETPLACEID - This header identifies the seller's eBay marketplace.<br><br>See <a href="/develop/api/sell/request_headers#marketplace-id-values " target="_blank ">Request Headers</a> for the marketplace ID values.<br><br><span class="tablenote"><b>Note:</b> If a marketplace ID value is not provided, the default value of <code>EBAY_US</code> is used.</span>
    # + filter - This parameter can be used to filter orders created within a specified date range. The filter uses the <code>orderCreationDate</code> field, which works similarly to the <code>transactionDate</code> filter used by the Transactions API. Currently, <code>orderCreationDate</code> is the only supported filter value.<p><span class="tablenote"><span style="color:#004680"><strong>Note: </strong>All dates must be input using UTC format (<code>YYYY-MM-DDTHH:MM:SS.SSSZ</code>) and should be adjusted accordingly for the local timezone of the user.</span></p><p><b>Default</b>: If no value is specified, results from the past year will be returned.</p> 
    # + return - returns can be any of following types 
    # http:Ok (The retrieved order earnings summary)
    # http:BadRequest (Bad Request)
    # http:Unauthorized (Unauthorized)
    # http:Forbidden (Forbidden)
    # http:InternalServerError (Internal Server Error)
    resource function get order_earnings_summary(@http:Header {name: "X-EBAY-C-MARKETPLACE-ID"} MarketplaceIdEnum xEBAYCMARKETPLACEID, string[]? filter) returns OrderEarningsSummary|ErrorBadRequest|ErrorUnauthorized|ErrorForbidden|ErrorInternalServerError {
        OrderEarningsSummary result = {
            orderCount: 42,
            grossAmount: newAmount("5120.00"),
            orderEarnings: newAmount("4388.60"),
            expenses: newAmount("611.40"),
            refunds: newAmount("120.00")
        };
        return result;
    }

    # List payouts
    #
    # + xEBAYCMARKETPLACEID - This header identifies the seller's eBay marketplace.<br><br>See <a href="/develop/api/sell/request_headers#marketplace-id-values" target="_blank ">Request Headers</a> for the marketplace ID values.<br><br><span class="tablenote"><b>Note:</b> If a marketplace ID value is not provided, the default value of <code>EBAY_US</code> is used.</span>
    # + 'limit - The number of payouts to return per page of the result set. Use this parameter in conjunction with the <b>offset</b> parameter to control the pagination of the output. <br><br> For example, if <b>offset</b> is set to <code>10</code> and <b>limit</b> is set to <code>10</code>, the method retrieves payouts 11 thru 20 from the result set. <br><br> <span class="tablenote"><strong>Note:</strong> This feature employs a zero-based list, where the first payout in the results set has an offset value of <code>0</code>. </span> <br><br> <b>Maximum:</b> <code>200</code> <br> <b>Default:</b> <code>20</code>
    # + offset - This integer value indicates the actual position that the first payout returned on the current page has in the results set. So, if you wanted to view the 11th payout of the result set, you would set the <strong>offset</strong> value in the request to <code>10</code>. <br><br>In the request, you can use the <b>offset</b> parameter in conjunction with the <b>limit</b> parameter to control the pagination of the output. For example, if <b>offset</b> is set to <code>30</code> and <b>limit</b> is set to <code>10</code>, the method retrieves payouts 31 thru 40 from the resulting collection of payouts.<br><br>To avoid poor response time, use <b>offset</b> values of less than <code>5000</code>.<br><br> <span class="tablenote"><strong>Note:</strong> This feature employs a zero-based list, where the first payout in the results set has an offset value of <code>0</code>.</span><br><br><b>Default:</b> <code>0</code> (zero)
    # + filter - The filter types that can be used here are discussed below. If none of these filters are used, all payouts in all states from within the last five years are returned:<br><ul><li><b>payoutDate</b>: search for payouts within a specific range of dates. The date format to use is <code>YYYY-MM-DDTHH:MM:SS.SSSZ</code>. Below is the proper syntax to use if filtering by a date range: <br><br><code>https://apiz.ebay.com/sell/finances/v1/payout?filter=payoutDate:[2024-12-17T00:00:01.000Z..2024-12-24T00:00:01.000Z]</code><br><br>Only payouts from the last five years can be retrieved, so make sure the starting date is less than five years in the past from the present time. Also, the maximum date range that can be specified through this date filter is 36 months, so make sure your specified date range is no more than 36 months.</li><li><b>lastAttemptedPayoutDate</b>: search for attempted payouts that failed within a specific range of dates. In order to use this filter, the <b>payoutStatus</b> filter must also be used and its value must be set to <code>RETRYABLE_FAILED</code>. The date format to use is <code>YYYY-MM-DDTHH:MM:SS.SSSZ</code>. The same syntax and requirements applicable to the <b>payoutDate</b> filter also apply to the <b>lastAttemptedPayoutDate</b> filter. <br><br>This filter is only applicable (and will return results) if one or more seller payouts have failed, but are retryable.</li> <li><b>payoutStatus</b>: search for payouts in a particular state. Only one payout state can be specified with this filter. For supported <b>payoutStatus</b> values, see <a href="/develop/api/sell/finances_api#sell-finances_api-payout-getpayouts.payoutstatusenum">PayoutStatusEnum</a>.<br><br>Below is the proper syntax to use if filtering by payout status: <br><br><code>https://apiz.ebay.com/sell/finances/v1/payout?filter=payoutStatus:{SUCCEEDED}</code></li><li><b>payoutReference</b>: returns  the two true (actual) payouts associated with the payoutReference id. This parameter can support up to 200 <b>payoutReference</b> inputs. This filter is <b>only</b> supported for mainland China sellers. Below is the proper syntax to use if filtering by a specific <b>payoutReference</b>:<br><br><code>https://apiz.ebay.com/sell/finances/v1/payout?filter=payoutReference:{5********3}</code></li></ul><br>If both the <b>payoutDate</b> and <b>payoutStatus</b> filters are used, payouts must satisfy both criteria to be returned
    # + sort - By default, payouts or failed payouts that match the input criteria are sorted in descending order according to the payout date/last attempted payout date (i.e., most recent payouts returned first).<br><br>To view payouts in ascending order instead (i.e., oldest payouts/attempted payouts first,) you would include the <b>sort</b> query parameter, and then set the value of its <b>field</b> parameter to <code>payoutDate</code> or <code>lastAttemptedPayoutDate</code> (if searching for failed, retryable payouts). Below is the proper syntax to use if filtering by a payout date range in ascending order:<br><br><code>https://apiz.ebay.com/sell/finances/v1/payout?filter=payoutDate:[2018-12-17T00:00:01.000Z..2018-12-24T00:00:01.000Z]&sort=payoutDate</code><br><br>Payouts can only be sorted according to payout date, and can not be sorted by payout status
    # + return - returns can be any of following types 
    # http:Ok (The retrieved payouts)
    # http:NoContent (No Content)
    # http:BadRequest (Bad Request)
    # http:Unauthorized (Unauthorized)
    # http:Forbidden (Forbidden)
    # http:InternalServerError (Internal Server Error)
    resource function get payout(@http:Header {name: "X-EBAY-C-MARKETPLACE-ID"} MarketplaceIdEnum xEBAYCMARKETPLACEID, int? 'limit, int? offset, string[]? filter, string[]? sort) returns Payouts|http:NoContent|ErrorBadRequest|ErrorUnauthorized|ErrorForbidden|ErrorInternalServerError {
        Payouts result = {
            href: "https://apiz.ebay.com/sell/finances/v1/payout?limit=20&offset=0",
            total: 1,
            offset: 0,
            'limit: 20,
            payouts: [newPayout("5000012345")]
        };
        return result;
    }

    # Get a payout
    #
    # + xEBAYCMARKETPLACEID - This header identifies the seller's eBay marketplace.<br><br>See <a href="/develop/api/sell/request_headers#marketplace-id-values" target="_blank ">Request Headers</a> for the marketplace ID values.<br><br><span class="tablenote"><b>Note:</b> If a marketplace ID value is not provided, the default value of <code>EBAY_US</code> is used.</span>
    # + payoutId - This path parameter is used to specify the unique identifier of the payout being retrieved. <br><br>Use the <a href="/develop/api/sell/finances_api#sell-finances_api-payout-getpayouts">getPayouts</a> method to retrieve payout IDs, or check Seller Hub to get the payout ID. 
    # + return - returns can be any of following types 
    # http:Ok (The retrieved payout)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not found)
    # http:InternalServerError (Internal Server Error)
    resource function get payout/[string payoutId](@http:Header {name: "X-EBAY-C-MARKETPLACE-ID"} string xEBAYCMARKETPLACEID) returns Payout|http:BadRequest|http:NotFound|http:InternalServerError {
        Payout result = newPayout(payoutId);
        return result;
    }

    # Get payout summary
    #
    # + xEBAYCMARKETPLACEID - This header identifies the seller's eBay marketplace.<br><br>See <a href="/develop/api/sell/request_headers#marketplace-id-values" target="_blank ">Request Headers</a> for the marketplace ID values.<br><br><span class="tablenote"><b>Note:</b> If a marketplace ID value is not provided, the default value of <code>EBAY_US</code> is used.</span>
    # + filter - The two filter types that can be used here are discussed below. One or both of these filter types can be used. If none of these filters are used, the data returned in the response will reflect all payouts in all states that have occurred within the last five years:<br><ul><li><b>payoutDate</b>: consider payouts processed within a specific range of dates. The date format to use is <code>YYYY-MM-DDTHH:MM:SS.SSSZ</code>. Below is the proper syntax to use if filtering by a date range: <br><br><code>https://apiz.ebay.com/sell/finances/v1/payout_summary?filter=payoutDate:[2024-12-17T00:00:01.000Z..2024-12-24T00:00:01.000Z]</code><br><br>Only payouts from the last five years can be retrieved, so make sure the starting date is less than five years in the past from the present time. Also, the maximum date range that can be specified through this date filter is 36 months, so make sure your specified date range is no more than 36 months.</li> <li><b>payoutStatus</b>: consider only the payouts in a particular state. Only one payout state can be specified with this filter. For supported <b>payoutStatus</b> values, see <a href="/develop/api/sell/finances_api#sell-finances_api-payout-getpayouts.payoutstatusenum">PayoutStatusEnum</a>.<br><br>Below is the proper syntax to use if filtering by payout status: <br><br><code>https://apiz.ebay.com/sell/finances/v1/payout_summary?filter=payoutStatus:{SUCCEEDED}</code></ul><br>If both the <b>payoutDate</b> and <b>payoutStatus</b> filters are used, only the payouts that satisfy both criteria are considered in the results
    # + return - returns can be any of following types 
    # http:Ok (The retrieved payout summary)
    # http:BadRequest (Bad Request)
    # http:Unauthorized (Unauthorized)
    # http:Forbidden (Forbidden)
    # http:InternalServerError (Internal Server Error)
    resource function get payout_summary(@http:Header {name: "X-EBAY-C-MARKETPLACE-ID"} MarketplaceIdEnum xEBAYCMARKETPLACEID, string[]? filter) returns PayoutSummaryResponse|ErrorBadRequest|ErrorUnauthorized|ErrorForbidden|ErrorInternalServerError {
        PayoutSummaryResponse result = {
            amount: newAmount("3250.75"),
            payoutCount: 4,
            transactionCount: 96
        };
        return result;
    }

    # Get seller funds summary
    #
    # + xEBAYCMARKETPLACEID - This header identifies the seller's eBay marketplace.<br><br>See <a href="/develop/api/sell/request_headers#marketplace-id-values" target="_blank ">Request Headers</a> for the marketplace ID values.<br><br><span class="tablenote"><b>Note:</b> If a marketplace ID value is not provided, the default value of <code>EBAY_US</code> is used.</span>
    # + return - returns can be any of following types 
    # http:Ok (The retrieved seller funds summary)
    # http:NoContent (No Content)
    # http:Unauthorized (Unauthorized)
    # http:Forbidden (Forbidden)
    # http:InternalServerError (Internal Server Error)
    resource function get seller_funds_summary(@http:Header {name: "X-EBAY-C-MARKETPLACE-ID"} MarketplaceIdEnum xEBAYCMARKETPLACEID) returns SellerFundsSummaryResponse|http:NoContent|ErrorUnauthorized|ErrorForbidden|ErrorInternalServerError {
        SellerFundsSummaryResponse result = {
            availableFunds: newAmount("1200.50"),
            processingFunds: newAmount("310.00"),
            fundsOnHold: newAmount("75.25"),
            totalFunds: newAmount("1585.75")
        };
        return result;
    }

    # Get transaction summary
    #
    # + xEBAYCMARKETPLACEID - This header identifies the seller's eBay marketplace.<br><br>See <a href="/develop/api/sell/request_headers#marketplace-id-values" target="_blank ">Request Headers</a> for the marketplace ID values.<br><br><span class="tablenote"><b>Note:</b> If a marketplace ID value is not provided, the default value of <code>EBAY_US</code> is used.</span>
    # + filter - Numerous filters are available for the <strong>getTransactionSummary</strong> method, and these filters are discussed below. One or more of these filter types can be used. The <b>transactionStatus</b> filter must be used. All other filters are optional. <ul><li><b>transactionStatus</b>: the data returned in the response pertains to the sales, payouts, and transfer status set. For supported <b>transactionStatus</b> values, see <a href="/api-docs/sell/finances/types/pay:TransactionStatusEnum" target="_blank ">TransactionStatusEnum</a>. <br><br>Below is the proper syntax to use when setting up the <b>transactionStatus</b> filter: <br><br><code>https://apiz.ebay.com/sell/finances/v1/transaction_summary?filter=transactionStatus:&#123;PAYOUT&#125;</code></li><li><b>transactionDate</b>: only consider monetary transactions that occurred within a specific range of dates.<br><br><span class="tablenote"><strong>Note:</strong> All dates must be input using UTC format (<code>YYYY-MM-DDTHH:MM:SS.SSSZ</code>) and should be adjusted accordingly for the local timezone of the user.</span><br><br>Below is the proper syntax to use if filtering by a date range: <br><br><code>https://apiz.ebay.com/sell/finances/v1/transaction_summary?filter=transactionDate:&#91;2024-10-23T00:00:01.000Z..2024-11-09T00:00:01.000Z&#93;</code><br><br><b>Note:</b>Only monetary transactions from the last five years can be retrieved, so make sure the starting date is less than five years in the past from the present time. Also, the maximum date range that can be specified through this date filter is 36 months, so make sure your specified date range is no more than 36 months.</li>  <li><b>transactionType</b>: only consider a specific type of monetary transaction. For supported <b>transactionType</b> values, see <a href="/api-docs/sell/finances/types/pay:TransactionTypeEnum" target="_blank ">TransactionTypeEnum</a>.<br><br>Below is the proper syntax to use if filtering by a monetary transaction type: <br><br><code>https://apiz.ebay.com/sell/finances/v1/transaction_summary?filter=transactionType:{SALE}</code></li><li><b>buyerUsername</b>: only consider monetary transactions involving a specific buyer (specified with the buyer's eBay username or user ID). Below is the proper syntax to use if filtering by a specific eBay buyer: <br><br><code>https://apiz.ebay.com/sell/finances/v1/transaction_summary?filter=buyerUsername:&#123;buyer1234&#125;</code> </li><li><b>payoutId</b>: only consider monetary transactions related to a specific seller payout (identified with a Payout ID). This value is auto-generated by eBay once the seller payout is set to be processed. Below is the proper syntax to use if filtering by a specific Payout ID: <br><br><code>https://apiz.ebay.com/sell/finances/v1/transaction_summary?filter=payoutId:&#123;5********8&#125;</code>  </li><li><b>transactionId</b>: the unique identifier of a monetary transaction. For a sales order, the <b>orderId</b> filter should be used instead. Only the monetary transaction(s) associated with this <b>transactionId</b> value are returned.<br><br><span class="tablenote"><strong>Note:</strong> This filter cannot be used alone; the <b>transactionType</b> must also be specified when filtering by transaction ID.</span><br><br>Below is the proper syntax to use if filtering by a specific transaction ID: <br><br><code>https://apiz.ebay.com/sell/finances/v1/transaction_summary?filter=transactionId:{0*-0***0-3***3}&filter=transactionType:{SALE}</code> </li><li><b>orderId</b>: the unique identifier of a sales order. For any other monetary transaction, the <b>transactionId</b> filter should be used instead. Only the monetary transaction(s) associated with this <b>orderId</b> value are returned. Below is the proper syntax to use if filtering by a specific order ID: <br><br><code>https://apiz.ebay.com/sell/finances/v1/transaction_summary?filter=orderId:{0*-0***0-3***3}</code> </li></ul> 
    # + return - returns can be any of following types 
    # http:Ok (The retrieved transaction summary)
    # http:BadRequest (Bad Request)
    # http:Unauthorized (Unauthorized)
    # http:Forbidden (Forbidden)
    # http:InternalServerError (Internal Server Error)
    resource function get transaction_summary(@http:Header {name: "X-EBAY-C-MARKETPLACE-ID"} MarketplaceIdEnum xEBAYCMARKETPLACEID, string[] filter) returns TransactionSummaryResponse|ErrorBadRequest|ErrorUnauthorized|ErrorForbidden|ErrorInternalServerError {
        TransactionSummaryResponse result = {
            creditCount: 12,
            creditAmount: newAmount("2400.00"),
            creditBookingEntry: "CREDIT",
            refundCount: 1,
            refundAmount: newAmount("35.00"),
            refundBookingEntry: "DEBIT",
            purchaseCount: 3,
            purchaseAmount: newAmount("89.90"),
            purchaseBookingEntry: "DEBIT"
        };
        return result;
    }

    # Get a transfer
    #
    # + xEBAYCMARKETPLACEID - This header identifies the seller's eBay marketplace.<br><br>See <a href="/develop/api/sell/request_headers#marketplace-id-values" target="_blank ">Request Headers</a> for the marketplace ID values.<br><br><span class="tablenote"><b>Note:</b> If a marketplace ID value is not provided, the default value of <code>EBAY_US</code> is used.</span>
    # + transferId - This path parameter is used to specify the unique identifier of the <code>TRANSFER</code> transaction type you wish to retrieve.<br><br>Use the <a href="/develop/api/sell/finances_api#sell-finances_api-transaction-gettransactions">getTransactions</a> method to retrieve this value by setting the <b>transactionType</b> filter to <code>TRANSFER</code>. The <b>transfer_id</b> value will then be returned in the <b>transaction_id</b> field of the response
    # + return - returns can be any of following types 
    # http:Ok (The retrieved transfer)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not found.)
    # http:InternalServerError (Internal Server Error.)
    resource function get transfer/[string transferId](@http:Header {name: "X-EBAY-C-MARKETPLACE-ID"} string xEBAYCMARKETPLACEID) returns Transfer|http:BadRequest|http:NotFound|http:InternalServerError {
        Transfer result = {
            transferId: transferId,
            transactionDate: "2026-02-20T14:00:00.000Z",
            transferAmount: newAmount("50.00"),
            transferDetail: {totalChargeNetAmount: newAmount("50.00")}
        };
        return result;
    }
}

// Service-mode response types. `bal openapi --mode client` collapses 4XX/5XX
// to `error` and never emits these, so they are defined here for the mock only.
public type ErrorBadRequest record {|
    *http:BadRequest;
    Error body;
|};

public type ErrorForbidden record {|
    *http:Forbidden;
    Error body;
|};

public type ErrorInternalServerError record {|
    *http:InternalServerError;
    Error body;
|};

public type ErrorNotFound record {|
    *http:NotFound;
    Error body;
|};

public type ErrorUnauthorized record {|
    *http:Unauthorized;
    Error body;
|};

# A name/value pair that describes a detail of an error condition
public type ErrorParameter record {
    # The name of the parameter
    string name?;
    # The value of the parameter
    string value?;
};

# This type defines the fields that can be returned in an error
public type Error record {
    # Name for the primary system where the error occurred. This is relevant for application errors
    string domain;
    # Further helps indicate which subsystem the error is coming from. System subcategories include: Initialization, Serialization, Security, Monitoring, Rate Limiting, etc
    string subdomain?;
    # An array of request elements most closely associated to the error
    string[] outputRefIds?;
    # A unique number to identify the error
    int:Signed32 errorId;
    # An array of request elements most closely associated to the error
    string[] inputRefIds?;
    # This enumerated type identifies the category of an error returned in the response.
    # | - **APPLICATION**: Indicates a server-side application error.
    # - **BUSINESS**: Indicates that the error is due to a business rule violation.
    # - **REQUEST**: Indicates that the error is caused by an invalid or missing value in the request
    ErrorCategoryEnum category;
    # A more detailed explanation of the error
    string longMessage?;
    # Information on how to correct the problem, in the end user's terms and language where applicable
    string message;
    # An array of name/value pairs that describe details the error condition. These are useful when multiple errors are returned
    ErrorParameter[] parameters?;
};

# This enumerated type identifies the category of an error returned in the response.
# | - **APPLICATION**: Indicates a server-side application error.
# - **BUSINESS**: Indicates that the error is due to a business rule violation.
# - **REQUEST**: Indicates that the error is caused by an invalid or missing value in the request
public type ErrorCategoryEnum "APPLICATION"|"BUSINESS"|"REQUEST";
