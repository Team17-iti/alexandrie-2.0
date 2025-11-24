# alexandrie-2.0

```mermaid
classDiagram
    Utilisateurs "1" -- "0..*" Emprunts : "réalise"
    Livres "1..*" -- "0..*" Auteurs : "écrit par"
    Livres "1" -- "0..*" Emprunts : "fait l’objet de"
    Utilisateurs "1" -- "0..*" Reservations : "réserve"
    Livres "1" -- "0..*" Reservations : "est réservée par"

    class Livres {
    +String isbn
    +String titre
    +List<Auteur> auteurs
    +String categorie
    +int anneePublication
    +String editeur
    +String langue
    +int nbPages
    +Format format
    +int nbExemplaires
    +String localisation
    +Etat etat
    +List<String> motsCles
    }
    class Utilisateurs {
    +String id
    +String nom
    +String prenom
    +String email
    +Date dateNaissance
    +String adresse
    +String telephone
    +TypeCompte typeCompte
    +Date dateInscription
    +Statut statut
    +int nbMaxEmprunts
    }
    class Emprunts {
    +String id
    +Utilisateur utilisateur
    +Ressource ressource
    +Date dateEmprunt
    +Date dateRetourPrevue
    +Date dateRetourEffective
    +StatutEmprunt statut
    +double penalites
    }
    class Reservations {
    +String id
    +Utilisateur utilisateur
    +Ressource ressource
    +Date dateReservation
    +Date dateExpiration
    +StatutReservation statut
    +int positionFileAttente
    }
    class Auteurs {
    +String id
    +String nomComplet
    +List<String> pseudonymes
    +Date dateNaissance
    +Date dateDeces
    +String nationalite
    +String biographie
    +String siteWeb
    +List<String> reseauxSociaux
    }
```