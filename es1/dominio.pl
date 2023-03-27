% Sintomi
symptom(fever).
symptom(cough).
symptom(headache).
symptom(rash).
symptom(sore_throat).

% Malattie
disease(cold).
disease(flu).
disease(measles).
disease(meningitis).
disease(scarlet_fever).

% Associazioni sintomo-malattia
symptom_of(fever, cold).
symptom_of(fever, flu).
symptom_of(fever, meningitis).
symptom_of(rash, measles).
symptom_of(rash, scarlet_fever).
symptom_of(cough, cold).
symptom_of(cough, flu).
symptom_of(headache, meningitis).
symptom_of(sore_throat, flu).
symptom_of(sore_throat, meningitis).

% Storia clinica del paziente
patient_history(john, [fever, cough, headache]).
patient_history(susan, [rash, sore_throat]).
patient_history(bob, [cough, headache]).
