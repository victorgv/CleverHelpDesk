package es.victorgv.cleverhelpdesk.model;

import javax.persistence.*;

@Entity
public class Project {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator= "project_id_generator")
    @SequenceGenerator(name="user_id_generator", sequenceName = "user_seq")
    private Long projectId;

    @Column(length = 60, nullable = false)
    private String name;
}
