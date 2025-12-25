# **ELT proces datasetu COMPANY**





V tomto projekte sa zameriavam na analýzu datasetu **COMPANY** zo Snowflake marketplace, ktorý je súčasťou [Snowflake Public Data (Free)](https://app.snowflake.com/marketplace/listing/GZTSZ290BV255/snowflake-public-data-products-snowflake-public-data-free?search=snowflake&originTab=provider&providerName=Snowflake+Public+Data+Products&profileGlobalName=GZTSZAS2KCS).

Pomocou ELT procesu v Snowflake vytváram dátový sklad (DWH) so Star schémou, ktorý umožňuje analytické spracovanie dát z oblasti firemnej štruktúry, korporátnych vzťahov a udalostí v čase. Výsledný dátový model umožňuje multidimenzionálnu analýzu firemných udalostí, porovnávanie spoločností, analýzu vzťahov medzi firmami, sledovanie vývoja v čase a ich vizualizáciu.



<br>



## **1. Úvod a popis zdrojových dát**



Dataset COMPANY sprístupňuje verejne dostupné údaje o spoločnostiach a ich ekosystéme, vrátane základných identifikačných údajov, organizačných charakteristík, vzťahov medzi spoločnosťami a záznamov o firemných udalostiach.



Analýza je zameraná najmä na:



* analýzu firemných udalostí a ich vývoja v čase
* porovnanie spoločností podľa rôznych charakteristík
* identifikáciu vzťahov medzi spoločnosťami
* analýzu vzťahov spoločností na cenné papiere
* identifikáciu trendov a frekvencie firemných udalostí



Zdrojové dáta pochádzajú z tabuliek:



* `COMPANY_INDEX` - centrálna tabuľka obsahujúca základné identifikačné údaje o spoločnostiach
* `COMPANY_CHARACTERISTICS` - charakteristiky spoločností s časovou platnosťou
* `COMPANY_DOMAIN_RELATIONSHIP` - vzťahy spoločností k doménam s definovaným obdobím platnosti
* `COMPANY_RELATIONSHIPS` - vzťahy medzi spoločnosťami
* `COMPANY_SECURITY_RELATIONSHIPS` - vzťahy spoločností na cenné papiere (ako akcie, dlhopisy)
* `COMPANY_EVENT_TRANSCRIPT_ATTRIBUTES` - údaje o firemných udalostiach vrátane textových transkriptov



<br>


### **1.1 Dátová architektúra**



#### **ERD - entitno-relačný diagram**



Surová vrstva obsahuje neupravené dáta z pôvodnej štruktúry datasetu, znázornené pomocou ERD. Vynechali sme PIT (point in time) tabuľky, lebo aj keď patria k datasetu, nie sú relevantné pre túto analýzu. Zdrojový dataset taktiež neobsahuje explicitne definované primárne kľúče, no pre účely ERD som ich definovala na základe logických súvislostí.


<p align="center">
  <img width="1360" height="1010" alt="ERD_Company" src="https://github.com/user-attachments/assets/73da9a80-c86e-400d-a587-8d85b874adc8" />
  <br>
  <em>Obrázok 1 – Entitno-relačný diagram Company datasetu</em>

</p>





<br>



## **2. Dimenzionálny model**



meowmeow







