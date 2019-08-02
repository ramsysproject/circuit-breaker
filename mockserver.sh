#!/usr/bin/env bash
docker run -d -p 1080:1080 jamesdbloom/mockserver

sleep 3

#### Check balance expectations

curl -v -X PUT "http://localhost:1080/mockserver/expectation" -d '{
  "httpRequest" : {
    "path" : "/Giftcard/checkbalance",
    "queryStringParameters" : {
      "giftCardNumber" : [ "1" ],
      "giftCardNumberCVV" : [ "1234" ],
      "countryCode" : [ "NL" ]
    }
  },
  "httpResponse" : {
    "statusCode" : 200,
    "body" : {
        "type" : "JSON",
        "json" : "{ \"giftCardBalance\": 100, \"error\": \"\" }"
    }
  }
}'

curl -v -X PUT "http://localhost:1080/mockserver/expectation" -d '{
  "httpRequest" : {
    "path" : "/Giftcard/checkbalance",
    "queryStringParameters" : {
      "giftCardNumber" : [ "1" ],
      "giftCardNumberCVV" : [ "1234" ],
      "countryCode" : [ "ZZ" ]
    }
  },
  "httpResponse" : {
    "statusCode" : 200,
    "body" : {
        "type" : "JSON",
        "json" : "{ \"giftCardBalance\": 0, \"error\": \"Invalid country received\" }"
    }
  }
}'

curl -v -X PUT "http://localhost:1080/mockserver/expectation" -d '{
  "httpRequest" : {
    "path" : "/Giftcard/checkbalance",
    "queryStringParameters" : {
      "giftCardNumber" : [ "1" ],
      "giftCardNumberCVV" : [ "9999" ],
      "countryCode" : [ "NL" ]
    }
  },
  "httpResponse" : {
    "statusCode" : 400
  }
}'

curl -v -X PUT "http://localhost:1080/mockserver/expectation" -d '{
  "httpRequest" : {
    "path" : "/Giftcard/checkbalance",
    "queryStringParameters" : {
      "giftCardNumber" : [ "1" ],
      "giftCardNumberCVV" : [ "1234" ],
      "countryCode" : [ "AAA" ]
    }
  },
  "httpResponse" : {
    "body" : "Bad Request"
  }
}'

#### Redeem expectations

curl -v -X PUT "http://localhost:1080/mockserver/expectation" -d '{
  "httpRequest" : {
    "path" : "/Giftcard/redeem",
    "queryStringParameters" : {
      "giftCardNumber" : [ "1" ],
      "giftCardNumberCVV" : [ "1234" ],
      "countryCode" : [ "NL" ],
      "amount" : [ "100.0" ]
    }
  },
  "httpResponse" : {
    "statusCode" : 200,
    "body" : {
        "type" : "JSON",
        "json" : "{ \"remainingGiftCardAmount\": 50, \"error\": \"\", \"authCode\": \"123456\" }"
    }
  }
}'

curl -v -X PUT "http://localhost:1080/mockserver/expectation" -d '{
  "httpRequest" : {
    "path" : "/Giftcard/redeem",
    "queryStringParameters" : {
      "giftCardNumber" : [ "1" ],
      "giftCardNumberCVV" : [ "1234" ],
      "countryCode" : [ "ZZ" ],
      "amount" : [ "100.0" ]
    }
  },
  "httpResponse" : {
    "statusCode" : 200,
    "body" : {
        "type" : "JSON",
        "json" : "{ \"remainingGiftCardAmount\": 0, \"error\": \"Invalid country received\", \"authCode\": \"\" }"
    }
  }
}'

curl -v -X PUT "http://localhost:1080/mockserver/expectation" -d '{
  "httpRequest" : {
    "path" : "/Giftcard/redeem",
    "queryStringParameters" : {
      "giftCardNumber" : [ "1" ],
      "giftCardNumberCVV" : [ "9999" ],
      "countryCode" : [ "NL" ],
      "amount" : [ "100.0" ]
    }
  },
  "httpResponse" : {
    "statusCode" : 400
  }
}'

curl -v -X PUT "http://localhost:1080/mockserver/expectation" -d '{
  "httpRequest" : {
    "path" : "/Giftcard/redeem",
    "queryStringParameters" : {
      "giftCardNumber" : [ "1" ],
      "giftCardNumberCVV" : [ "9999" ],
      "countryCode" : [ "AAA" ],
      "amount" : [ "100.0" ]
    }
  },
  "httpResponse" : {
    "statusCode" : 400,
    "body" : "Bad Request"
  }
}'