package com.emramirez.circuitbreaker.controller;

import com.emramirez.circuitbreaker.client.GiftCardClient;
import com.emramirez.circuitbreaker.model.GiftCard;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@RestController
@RequestMapping("/gift-cards")
@RequiredArgsConstructor
public class GiftCardController {

    private final GiftCardClient giftCardClient;

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity getGiftCardById(@PathVariable Long id) {
        Optional<GiftCard> giftCard = giftCardClient.findGiftCard(id);

        if (!giftCard.isPresent()) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(giftCardClient.findGiftCard(id));
    }
}
