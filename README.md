# **ELT proces datasetu OUR\_WORLD\_IN\_DATA**





V tomto projekte sa zameriavam na analýzu datasetu **OUR\_WORLD\_IN\_DATA (OWID)** zo Snowflake marketplace, ktorý je súčasťou [Snowflake Public Data (Free)](https://app.snowflake.com/marketplace/listing/GZTSZ290BV255/snowflake-public-data-products-snowflake-public-data-free?search=snowflake&originTab=provider&providerName=Snowflake+Public+Data+Products&profileGlobalName=GZTSZAS2KCS).

Pomocou ELT procesu v Snowflake vytváram dátový sklad (DWH) so Star schémou. OWID nám poskytuje dáta o socio-ekonomických a enviromentálnych ukazovateľoch v závislosti od geografickej lokality a času. Výsledný dátový model nám umožňuje multidimenzionálnu analýzu trendov, porovnávanie krajín, sledovanie vývoja vybraných ukazovateľov v čase a ich vizualizáciu.



<br>



## **1. Úvod a popis zdrojových dát**



Dataset OWID sprístupňuje verejne dostupné údaje o rôznych oblastiach, ako sú zdravie, populácia, ekonomika, životné prostredie či vzdelávanie.



Analýza je zameraná najmä na:



* vývoj hodnôt jednotlivých indikátorov v čase
* porovnanie geografických jednotiek (krajiny, regióny)
* identifikáciu trendov a extrémov v dátach



Zdrojové dáta pochádzajú z tabuliek:



* `OUR_WORLD_IN_DATA_ATTRIBUTES` - metadáta jednotlivých ukazovateľov (názov, jednotka, typ merania)
* `OUR_WORLD_IN_DATA_TIMESERIES` - hlavná tabuľka dát, ktorá obsahuje samotné merania ukazovateľov v čase
* `GEOGRAPHY_INDEX` - informácie o geografických jednotkách 




<br>


### **1.1 Dátová architektúra**



#### **ERD - entitno-relačný diagram**



Surová vrstva obsahuje neupravené dáta z pôvodnej štruktúry datasetu, znázornené pomocou ERD. Vynechali sme PIT (point in time) tabuľky, lebo aj keď patria k datasetu, nie sú relevantné pre túto analýzu. Zdrojový dataset taktiež neobsahuje explicitne definované primárne kľúče, no pre účely ERD som ich definovala na základe logických súvislostí.


<p align="center">
  <img width="730" height="582" alt="ERD_OWID" src="https://github.com/user-attachments/assets/24f801eb-91e2-497c-8807-adaeff6cfca4" />
  <br>
  <em>Obrázok 1 – Entitno-relačný diagram OWID</em>
</p>





<br>



## **2. Dimenzionálny model**



meowmeow







