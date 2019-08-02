package com.emramirez.circuitbreaker.client;

import com.emramirez.circuitbreaker.model.GiftCard;
import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
import com.netflix.hystrix.contrib.javanica.annotation.HystrixProperty;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.Optional;

@Component
@RequiredArgsConstructor
@Slf4j
public class GiftCardClient {

    public static final String GIFT_CARD_NUMBER = "giftCardNumber";
    public static final String GIFT_CARD_NUMBER_CVV = "giftCardNumberCVV";
    public static final String COUNTRY_CODE = "countryCode";

    @Value("${gift.card.url}")
    private String giftCardUrl;
    private final RestTemplate restTemplate;

    /**
     * Set the circuit breaker to be tripped if the number of failing requests is 30% in a 20 sec windows
     * for a total of 3 requests. Sleep windows is set to 10000 ms.
     * @param id
     * @return
     */
    @HystrixCommand(fallbackMethod = "reliable",
            commandProperties = {
                    @HystrixProperty(name="circuitBreaker.requestVolumeThreshold", value="3"),
                    @HystrixProperty(name="circuitBreaker.errorThresholdPercentage", value="30"),
                    @HystrixProperty(name="circuitBreaker.sleepWindowInMilliseconds", value="10000"),
            }
    )
    public Optional<GiftCard> findGiftCard(Long id) {
        String uriTemplate = String.format("%s/Giftcard/checkbalance", giftCardUrl);
        URI uri = UriComponentsBuilder.fromUriString(uriTemplate)
                .queryParam(GIFT_CARD_NUMBER, "1")
                .queryParam(GIFT_CARD_NUMBER_CVV, "1234")
                .queryParam(COUNTRY_CODE, "AAA").build().toUri();

        log.info("Executing get call for gift card");
        GiftCard result = restTemplate.getForObject(uri, GiftCard.class);

        return Optional.of(result);
    }

    public Optional<GiftCard> reliable(Long id) {
        log.info("Circuit breaker is open");
        return Optional.empty();
    }
}
