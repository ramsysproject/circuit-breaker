package com.emramirez.circuitbreaker.model;

import lombok.Data;

@Data
public class GiftCard {

    private Long id;
    private Long giftCardNumber;
    private Integer giftCardNumberCvv;
    private String countryCode;
}
