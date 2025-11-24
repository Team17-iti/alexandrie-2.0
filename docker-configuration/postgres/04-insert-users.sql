\c alexandrie;

DO $$
DECLARE
    v_counter INT := 1;
    v_nom VARCHAR(100);
    v_prenom VARCHAR(100);
    v_email VARCHAR(255);
    v_type VARCHAR(50);
    v_date_naissance DATE;
    v_adresse TEXT;
    v_telephone VARCHAR(20);
    
    -- Arrays for random data generation
    a_noms TEXT[] := ARRAY['Martin', 'Bernard', 'Thomas', 'Petit', 'Robert', 'Richard', 'Durand', 'Dubois', 'Moreau', 'Laurent', 'Simon', 'Michel', 'Lefebvre', 'Leroy', 'Roux', 'David', 'Bertrand', 'Morel', 'Fournier', 'Girard', 'Bonnet', 'Dupont', 'Lambert', 'Fontaine', 'Rousseau', 'Vincent', 'Muller', 'Lefevre', 'Faure', 'Andre', 'Mercier', 'Blanc', 'Guerin', 'Boyer', 'Garnier', 'Chevalier', 'Francois', 'Legrand', 'Gauthier', 'Garcia'];
    a_prenoms TEXT[] := ARRAY['Jean', 'Marie', 'Philippe', 'Nathalie', 'Michel', 'Isabelle', 'Alain', 'Sylvie', 'Patrick', 'Catherine', 'Nicolas', 'Martine', 'Christophe', 'Christine', 'Pierre', 'Francoise', 'Christian', 'Valerie', 'Eric', 'Sandrine', 'Frederic', 'Stephanie', 'Laurent', 'Veronique', 'Stephane', 'Sophie', 'David', 'Celine', 'Pascal', 'Chantal', 'Daniel', 'Joelle', 'Alexander', 'Julie', 'Antoine', 'Sarah', 'Julien', 'Emilie', 'Sebastien', 'Laure'];
    a_types TEXT[] := ARRAY['etudiant', 'enseignant', 'chercheur', 'grand public'];
    a_rues TEXT[] := ARRAY['Rue de la Paix', 'Avenue Victor Hugo', 'Boulevard Haussmann', 'Place de la République', 'Rue du Commerce', 'Avenue des Champs-Élysées', 'Quai d''Orsay', 'Rue de Rivoli', 'Boulevard Saint-Germain', 'Rue Saint-Antoine'];
    a_villes TEXT[] := ARRAY['Paris', 'Lyon', 'Marseille', 'Toulouse', 'Nice', 'Nantes', 'Strasbourg', 'Montpellier', 'Bordeaux', 'Lille'];

BEGIN
    WHILE v_counter <= 200 LOOP
        -- Generate Name
        v_nom := a_noms[1 + floor(random() * array_length(a_noms, 1))::int];
        v_prenom := a_prenoms[1 + floor(random() * array_length(a_prenoms, 1))::int];
        
        -- Generate Email (ensure uniqueness with counter if needed, but simple combination is usually fine for test data)
        v_email := lower(v_prenom || '.' || v_nom || v_counter || '@example.com');
        
        -- Generate Type
        v_type := a_types[1 + floor(random() * array_length(a_types, 1))::int];
        
        -- Generate Other Fields
        v_date_naissance := CURRENT_DATE - (floor(random() * 20000 + 6500)::int || ' days')::interval; -- Age between ~18 and ~70
        v_adresse := floor(random() * 100 + 1)::int || ' ' || a_rues[1 + floor(random() * array_length(a_rues, 1))::int] || ', ' || a_villes[1 + floor(random() * array_length(a_villes, 1))::int];
        v_telephone := '0' || (floor(random() * 5 + 1)::int + 5) || lpad(floor(random() * 100000000)::text, 8, '0');
        
        BEGIN
            INSERT INTO utilisateurs (nom, prenom, email, date_naissance, adresse, telephone, type_compte, statut, nb_max_emprunts)
            VALUES (v_nom, v_prenom, v_email, v_date_naissance, v_adresse, v_telephone, v_type, 'actif', 
                CASE 
                    WHEN v_type = 'etudiant' THEN 5
                    WHEN v_type = 'enseignant' THEN 10
                    WHEN v_type = 'chercheur' THEN 15
                    ELSE 3 
                END
            );
            
            v_counter := v_counter + 1;
        EXCEPTION WHEN unique_violation THEN
            -- Ignore and retry (though adding counter to email makes it unlikely)
        END;
    END LOOP;
END $$;
