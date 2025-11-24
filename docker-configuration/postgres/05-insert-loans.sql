\c alexandrie;

DO $$
DECLARE
    v_counter INT := 1;
    v_utilisateur_id INT;
    v_isbn VARCHAR(13);
    v_date_emprunt TIMESTAMP;
    v_date_retour_prevue TIMESTAMP;
    v_date_retour_effective TIMESTAMP;
    v_statut VARCHAR(50);
    v_penalites DECIMAL(10, 2);
    
BEGIN
    WHILE v_counter <= 300 LOOP
        -- Select random user and book
        SELECT id INTO v_utilisateur_id FROM utilisateurs ORDER BY RANDOM() LIMIT 1;
        SELECT isbn INTO v_isbn FROM livres ORDER BY RANDOM() LIMIT 1;
        
        -- Determine status based on counter to ensure requirements are met
        IF v_counter <= 50 THEN
            -- At least 50 'terminé'
            v_statut := 'terminé';
            v_date_emprunt := CURRENT_TIMESTAMP - (floor(random() * 300 + 30)::int || ' days')::interval;
            v_date_retour_prevue := v_date_emprunt + INTERVAL '14 days';
            v_date_retour_effective := v_date_emprunt + (floor(random() * 14)::int || ' days')::interval; -- Returned on time or early
            v_penalites := 0;
        ELSIF v_counter <= 80 THEN
             -- At least 30 'en cours'
            v_statut := 'en cours';
            v_date_emprunt := CURRENT_TIMESTAMP - (floor(random() * 10)::int || ' days')::interval; -- Recent loan
            v_date_retour_prevue := v_date_emprunt + INTERVAL '14 days';
            v_date_retour_effective := NULL;
            v_penalites := 0;
        ELSIF v_counter <= 100 THEN
            -- At least 20 'en retard'
            v_statut := 'en retard';
            v_date_emprunt := CURRENT_TIMESTAMP - (floor(random() * 60 + 20)::int || ' days')::interval; -- Old loan
            v_date_retour_prevue := v_date_emprunt + INTERVAL '14 days';
            v_date_retour_effective := NULL;
            -- Calculate penalty (e.g., 0.50 per day overdue)
            v_penalites := EXTRACT(DAY FROM (CURRENT_TIMESTAMP - v_date_retour_prevue)) * 0.50;
        ELSE
            -- Random mix for the rest (mostly terminé or en cours to be realistic)
            IF random() < 0.7 THEN
                v_statut := 'terminé';
                v_date_emprunt := CURRENT_TIMESTAMP - (floor(random() * 300 + 30)::int || ' days')::interval;
                v_date_retour_prevue := v_date_emprunt + INTERVAL '14 days';
                v_date_retour_effective := v_date_emprunt + (floor(random() * 20)::int || ' days')::interval;
                IF v_date_retour_effective > v_date_retour_prevue THEN
                     v_penalites := EXTRACT(DAY FROM (v_date_retour_effective - v_date_retour_prevue)) * 0.50;
                ELSE
                     v_penalites := 0;
                END IF;
            ELSE
                v_statut := 'en cours';
                v_date_emprunt := CURRENT_TIMESTAMP - (floor(random() * 10)::int || ' days')::interval;
                v_date_retour_prevue := v_date_emprunt + INTERVAL '14 days';
                v_date_retour_effective := NULL;
                v_penalites := 0;
            END IF;
        END IF;

        BEGIN
            INSERT INTO emprunts (utilisateur_id, ressource_isbn, date_emprunt, date_retour_prevue, date_retour_effective, statut, penalites)
            VALUES (v_utilisateur_id, v_isbn, v_date_emprunt, v_date_retour_prevue, v_date_retour_effective, v_statut, v_penalites);
            
            v_counter := v_counter + 1;
        EXCEPTION WHEN OTHERS THEN
            -- Ignore errors (e.g. if we accidentally picked a book that doesn't exist, though unlikely with the SELECT)
        END;
    END LOOP;
END $$;
