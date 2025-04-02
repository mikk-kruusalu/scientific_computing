# Teadusarvutused

Esimene projekt on komposiitmaterjali efektiivsete Youngi mooduli ja Poissoni teguri leidmise peale.

- [x] Lihtsa talaga tõmbekatse.
- [x] Talal on viis paralleelset kiudu, tõmbekatse.
- [ ] Arvutada samad asjad peenema ja jämedama võrguga.
- [ ] Lisada päris materjalide omadused paralleelsete kiudude mudelis.
- [ ] Paralleelsete kiududega teha tõmbekatsed nii piki kui risti suunas ja võrrelda tegureid.
- [?] Kas sellest piisab või on vaja teha ka suvaliste lühikeste fiibritega?
- [ ] Esitlus

Kui aega on

- [ ] Automaatselt Youngi mooduli ja Poissoni teguri arvutamine, s.t mingi skript, mis `.vtu` failist otse arvutab need.

## Töövoog (for stupid)

Lae moodulid terminalis
module load rocky8-spack gmsh elmerfem
module load paraview/5.12.1-gcc-10.3.0-dotq

1. Teha geomeetria (`.geo`) fail, mis defineerib kujundi 
2. Teha `.sif` fail, mis määrab simulatsiooni jaoks paremeetrid ja ääretingimused
3. Jooksuta `job.slurm`
	* määrab klastri ressursse
	* laadib moodulid gmsh, elmerfm
	* gmsh loeb `.geo` faili, teeb geomeetria ja meshi (`.msh`)
	* Elmergrid tõlgib gmsh meshi ümber Elmerile loetavaks
	* `ELMERSOLVER_STARTINFO` määrab `case.sif` kasutamise ja Elmersolver loeb lahendab ülesande
4. Lahendid lähevad kausta, `.vtu` failina
5. Tulemusi saab näha paraview'ga.
	* open `.vtu` fail
	* Coloring -> displacement ja magnitude 
	* Filters -> Alphabetical -> Plot over line
	* Kasutad mingeid arve, et leida Youngi moodul ja Poissooni tegur

