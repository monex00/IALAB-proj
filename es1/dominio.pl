% Sintomi
symptom(febbre).
symptom(tosse).
symptom(mal_di_testa).
symptom(eruzione_cutanea).
symptom(mal_di_gola).

% Malattie
disease(influenza).
disease(raffreddore).
disease(morbillo).
disease(meningite).
disease(scarlattina).

% sintomo-malattia
symptom_of(febbre, influenza).
symptom_of(febbre, raffreddore).
symptom_of(febbre, meningite).
symptom_of(eruzione_cutanea, morbillo).
symptom_of(eruzione_cutanea, scarlattina).
symptom_of(tosse, influenza).
symptom_of(tosse, raffreddore).
symptom_of(mal_di_testa, meningite).
symptom_of(mal_di_gola, raffreddore).
symptom_of(mal_di_gola, meningite).

prob_disease(Disease, Patient, Probability) :-
    patient_history(Patient, Symptoms),
    disease(Disease),
    findall(Symptom, symptom_of(Symptom, Disease), DiseaseSymptoms),
    intersection(Symptoms, DiseaseSymptoms, Intersection),
    length(Intersection, IntersectionLength),
    length(DiseaseSymptoms, DiseaseSymptomsLength),
    Probability is IntersectionLength / DiseaseSymptomsLength.


% Storia clinica
patient_history(john, [febbre, tosse, mal_di_testa]).
patient_history(susan, [eruzione_cutanea, mal_di_gola]).
patient_history(bob, [tosse, mal_di_testa]).
