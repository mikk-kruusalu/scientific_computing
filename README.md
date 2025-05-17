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

Olulised failid on kõik kasutas `radiator/buoyantPimpleFoam`. nostl kaustad on ainult case üles seadmiseks ja need kasutavad ainult blockMesh'i ehk väga primitiivne geomeetria. withstl kaust sisaldab juba radiaatori stl faili.

Arvutuste jooksutamiseks veendu, et oled õiges case kasutas (nostl, withstl) ja seejärel
```bash
sbatch mesh.slurm
sbatch solve.slurm
```
Kuna võrgu tegemine võtab üpris kaua aega, siis lõin arvutamise ja võrgutamise kaheks osaks. Kui arvutamine on jõudnud poole peale ja siis klaster ajalimiidi tõttu ära tapab, siis on soovituslik järgmiseks jooksuks välja kommenteerida `solve.slurm` failis rida `decomposePar -force`. Arvutamine jätkub sealt kust pooleli jäi.

Kui tegu on nostl kaustaga, siis piisab ühest käsust `sbatch job.slurm`.
 
Minimaalne osa
- [x] Blockmeshiga taustavõrk (`blockMeshDict`)
- [x] LaplacianFoam simualtion diffusioonist, töötab
- [x] Üle vaadata, kuidas konstantse soojusvõimsuse ääretingumust kasutada
- [x] BouyantSimpleFoam simulatioon konvektsioonist.
- [x] buoyantPimpleFoam suure kasti ääretingimused peavad olema nagu vaba õhk.
- [x] Radikas sisse lisada, (stl exists). SnappyHexMesh'iga uus võrk genereerida.
- [x] Paraviewst ilusad pildid + radika temp
    - [x] Radika keskmine temperatuur ajast (koos standardhälbega)
    - [x] Streamlinedest ilus pilt viimase aja jaoks, nii, et kogu domeen on FeatureEdges asendis ja värvid kuidagi, et saab midagi aru ka. Selleks kasuta filtreid Stream Tracer ja Glyph.
    - [x] Eelmisest kiire video.
    - [x] Streamlinede pilt ka aja 0.1 jaoks, seal on mingi huvitav olukord, mida võiks klassis arutada.
    - [x] Võrgust pildid. Läbilõige xy-tasandil, nii et radikas oleks näha ja sama xz-tasandi jaoks. Selleks on Slice filter. 

Võiks teha:
- [ ] Radika sisepinnale const soojusvõimsus
- [ ] Sim ümber teha, et kasutaks chtMultiRegionSimpleFoam (solver kasutad laplacianfoam radika jaoks, bouyant simple foami ümritseva õhu jaoks)

## Kolmas projekt
### Teise projekti paraleeliseerumise hindamine
Teise projekti paraleelseks tegemine tähendab, et tõstame `#SBATCH --ntasks` arvu ja ideaalis võiks simulatsioon kiiremini laheneda.
Selleks teeme loogika, mis muudab vajalikke parameetreid, jooksutab simulatsioone ja mõõdab kulunud aega.

- [x] Teha fail, mis valmistab ette õiged parameetrid simulatsiooniks (`intern.slurm`)
    - [x] `ntasks=N` väärtust slurm failis
    - [x] decomposeParDict `numberOfSubdomains N;` ja coeffs `n           (3 3 2);`
        - [x] teha loop, mis võtab `N` ja jagab `n` muutujale laiali `(N/3 N/3 N/3 + jääk)` (või midagi)
- [x] Teha loogika, mis logib `N` ja `srun buoyantPimpleFoam -parallel ` aega (`intern.slurm`)
- [x] Mõelda välja kuidas jooksutada runne (`manager.slurm`)
    - [ ] Kas teha kuidagi hoopis uus `withstl=parallel` kaust iga erineva `N` jooksu jaoks
    - [x] Kas teha järjest neid jookse (lihtsam)

### Kasutamine

1. Navigeeri kausta `radiator/buoyantPimpleFoam`.
2. Kasuta skripti, et teha arvutuse jaoks uus kaust `bash parallel-dir.sh n`, ku `n` on tuumade arv.
3. Navigeeri kausta `withstl-parallel-n`.
4. Kasuta skripti, et automaatselt muuta domeeni dekompositsiooni ja sisse anda klastri töö `bash parallel-test.sh n`.

