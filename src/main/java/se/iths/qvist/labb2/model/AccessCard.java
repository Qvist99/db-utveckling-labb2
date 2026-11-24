package se.iths.qvist.labb2.model;

import java.time.LocalDate;

public class AccessCard {
    private int cardNumber;
    private LocalDate dateOfIssue;
    private LocalDate finalValidityDate;

    public AccessCard(int cardNumber, LocalDate dateOfIssue, LocalDate finalValidityDate) {
        this.cardNumber = cardNumber;
        this.dateOfIssue = dateOfIssue;
        this.finalValidityDate = finalValidityDate;
    }

    public int getCardNumber() {
        return cardNumber;
    }

    public LocalDate getDateOfIssue() {
        return dateOfIssue;
    }

    public LocalDate getFinalValidityDate() {
        return finalValidityDate;
    }
}
