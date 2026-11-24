package se.iths.qvist.labb2.model;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Employee {
    private int id;
    private String firstName;
    private String lastName;
    private String email;
    private LocalDate employedAt;
    private Department department;
    private AccessCard accessCard;
    private List<Qualification> qualifications = new ArrayList<>();

    public Employee(int id, String firstName, String lastName, String email, LocalDate employedAt, Department department) {
        if (department == null) {
            throw new IllegalArgumentException("An employee must belong to a department");
        }

        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.employedAt = employedAt;
        this.department = department;
    }


    public int getId() {
        return id;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public String getEmail() {
        return email;
    }

    public LocalDate getEmployedAt() {
        return employedAt;
    }

    public Department getDepartment() {
        return department;
    }

    public AccessCard getAccessCard() {
        return accessCard;
    }

    public void setAccessCard(AccessCard accessCard) {
        this.accessCard = accessCard;
    }

    public boolean addQualification(Qualification qualification) {
        if (qualification == null || qualifications.contains(qualification)) {
            return false; //Either already owns this qualification or null passed
        }

        qualifications.add(qualification);
        return true;
    }

    public List<Qualification> getQualifications() {
        return Collections.unmodifiableList(qualifications);
    }

}
