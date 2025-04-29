# Teadusarvutused

## Esimene projekt
### Komposiitmaterjali efektiivsete Youngi mooduli ja Poissoni teguri leidmise peale.

- [x] Lihtsa talaga tõmbekatse.
- [x] Talal on viis paralleelset kiudu, tõmbekatse.
- [x] Arvutada samad asjad peenema ja jämedama võrguga.
- [x] Lisada päris materjalide omadused paralleelsete kiudude mudelis.
- [x] Paralleelsete kiududega teha tõmbekatsed nii piki kui risti suunas ja võrrelda tegureid.
- [x] Arvutada nihkeelastsusmoodulid.
- [x] Esitlus

Kui aega on

- [ ] Automaatselt Youngi mooduli ja Poissoni teguri arvutamine, s.t mingi skript, mis `.vtu` failist otse arvutab need.

## Teine projekt
### Radiaatori jahutuse simulatsioon, soojuslevi ja õhu liikumine.

Minimaalne osa
- [x] Blockmeshiga taustavõrk (`blockMeshDict`)
- [x] LaplacianFoam simualtion diffusioonist, töötab
- [ ] Üle vaadata, kuidas konstantse soojusvõimsuse ääretingumust kasutada
- [x] BouyantSimpleFoam simulatioon konvektsioonist.
- [ ] buoyantPimpleFoam suure kasti ääretingimused peavad olema nagu vaba õhk.
- [ ] Radikas sisse lisada, (stl exists). SnappyHexMesh'iga uus võrk genereerida.
- [ ] BouyantSimpleFoamiga uuesti simulatsioon, uue võrguga, kus radika välispind on const soojusvõimsusega
- [ ] Paraviewst ilusad pildid + radika temp

Võiks teha:
- [ ] Radika sisepinnale const soojusvõimsus
- [ ] Sim ümber teha, et kasutaks chtMultiRegionSimpleFoam (solver kasutad laplacianfoam radika jaoks, bouyant simple foami ümritseva õhu jaoks)
