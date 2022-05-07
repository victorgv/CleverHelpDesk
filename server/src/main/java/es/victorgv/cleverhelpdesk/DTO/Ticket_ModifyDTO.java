package es.victorgv.cleverhelpdesk.DTO;

import java.time.LocalDate;

public class Ticket_ModifyDTO {
    private Long ticketId;
    private LocalDate opened; // DATE cuando se crea
    private LocalDate assigned; // DATE cuando se asigna
    private LocalDate closed; // DATE cuando se cierra
    private String subject;
    private String description;
    private Long priority;
    private Long  masterType_typeId;
    private Long masterStatus_statusId;
    private Long userOpenedId_userId;
    private Long userAssignedId_userId;
    private Long relatedProjectId;

    public Long getTicketId() {
        return ticketId;
    }

    public void setTicketId(Long ticketId) {
        this.ticketId = ticketId;
    }

    public LocalDate getOpened() {
        return opened;
    }

    public void setOpened(LocalDate opened) {
        this.opened = opened;
    }

    public LocalDate getAssigned() {
        return assigned;
    }

    public void setAssigned(LocalDate assigned) {
        this.assigned = assigned;
    }

    public LocalDate getClosed() {
        return closed;
    }

    public void setClosed(LocalDate closed) {
        this.closed = closed;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Long getPriority() {
        return priority;
    }

    public void setPriority(Long priority) {
        this.priority = priority;
    }

    public Long getMasterType_typeId() {
        return masterType_typeId;
    }

    public void setMasterType_typeId(Long masterType_typeId) {
        this.masterType_typeId = masterType_typeId;
    }

    public Long getMasterStatus_statusId() {
        return masterStatus_statusId;
    }

    public void setMasterStatus_statusId(Long masterStatus_statusId) {
        this.masterStatus_statusId = masterStatus_statusId;
    }

    public Long getUserOpenedId_userId() {
        return userOpenedId_userId;
    }

    public void setUserOpenedId_userId(Long userOpenedId_userId) {
        this.userOpenedId_userId = userOpenedId_userId;
    }

    public Long getUserAssignedId_userId() {
        return userAssignedId_userId;
    }

    public void setUserAssignedId_userId(Long userAssignedId_userId) {
        this.userAssignedId_userId = userAssignedId_userId;
    }

    public Long getRelatedProjectId() {
        return relatedProjectId;
    }

    public void setRelatedProjectId(Long relatedProjectId) {
        this.relatedProjectId = relatedProjectId;
    }
}
