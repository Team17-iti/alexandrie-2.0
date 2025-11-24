\c alexandrie;

DO $$
DECLARE
    v_counter INT := 1;
    v_utilisateur_id INT;
    v_isbn VARCHAR(13);
    v_date_reservation TIMESTAMP;
    v_date_expiration TIMESTAMP;
    v_statut VARCHAR(50);
    v_position INT;
    
    -- Array for random status generation
    a_statuts TEXT[] := ARRAY['En Attente', 'Disponible', 'Annulée', 'Expirée'];

BEGIN
    WHILE v_counter <= 50 LOOP
        -- Select random user and book
        SELECT id INTO v_utilisateur_id FROM utilisateurs ORDER BY RANDOM() LIMIT 1;
        SELECT isbn INTO v_isbn FROM livres ORDER BY RANDOM() LIMIT 1;
        
        -- Select random status
        v_statut := a_statuts[1 + floor(random() * array_length(a_statuts, 1))::int];
        
        -- Set fields based on status
        IF v_statut = 'En Attente' THEN
            v_date_reservation := CURRENT_TIMESTAMP - (floor(random() * 30)::int || ' days')::interval;
            v_date_expiration := NULL;
            v_position := floor(random() * 5 + 1)::int;
        ELSIF v_statut = 'Disponible' THEN
            v_date_reservation := CURRENT_TIMESTAMP - (floor(random() * 10)::int || ' days')::interval;
            v_date_expiration := CURRENT_TIMESTAMP + (floor(random() * 7 + 1)::int || ' days')::interval; -- Expires in future
            v_position := 0;
        ELSIF v_statut = 'Annulée' THEN
            v_date_reservation := CURRENT_TIMESTAMP - (floor(random() * 60 + 30)::int || ' days')::interval;
            v_date_expiration := NULL;
            v_position := NULL;
        ELSIF v_statut = 'Expirée' THEN
            v_date_reservation := CURRENT_TIMESTAMP - (floor(random() * 60 + 30)::int || ' days')::interval;
            v_date_expiration := v_date_reservation + INTERVAL '7 days'; -- Expired in past
            v_position := NULL;
        END IF;

        BEGIN
            INSERT INTO reservations (utilisateur_id, ressource_isbn, date_reservation, date_expiration, statut, position_file_attente)
            VALUES (v_utilisateur_id, v_isbn, v_date_reservation, v_date_expiration, v_statut, v_position);
            
            v_counter := v_counter + 1;
        EXCEPTION WHEN OTHERS THEN
            -- Ignore errors
        END;
    END LOOP;
END $$;
