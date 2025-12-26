# **ELT proces datasetu COMPANY**





V tomto projekte sa zameriavam na analýzu datasetu **COMPANY** zo Snowflake marketplace, ktorý je súčasťou [Snowflake Public Data (Free)](https://app.snowflake.com/marketplace/listing/GZTSZ290BV255/snowflake-public-data-products-snowflake-public-data-free?search=snowflake&originTab=provider&providerName=Snowflake+Public+Data+Products&profileGlobalName=GZTSZAS2KCS).

Pomocou ELT procesu v Snowflake vytváram dátový sklad (DWH) so Star schémou, ktorý umožňuje analytické spracovanie dát z oblasti firemnej štruktúry, korporátnych vzťahov a udalostí v čase. Výsledný dátový model umožňuje multidimenzionálnu analýzu firemných udalostí, porovnávanie spoločností, sledovanie vývoja v čase a ich vizualizáciu.



<br>



## **1. Úvod a popis zdrojových dát**



Dataset COMPANY sprístupňuje verejne dostupné údaje o spoločnostiach a ich ekosystéme, vrátane základných identifikačných údajov, organizačných charakteristík, vzťahov medzi spoločnosťami a záznamov o firemných udalostiach.



Analýza je zameraná najmä na:



* analýzu firemných udalostí a ich vývoja v čase
* porovnanie spoločností na základe počtu a frekvencie udalostí
* identifikáciu trendov a frekvencie firemných udalostí
* analýzu odstupov medzi jednotlivými udalosťami spoločností

Vzťahy medzi spoločnosťami, doménami a cennými papiermi nie sú priamo analyzované v dimenzionálnom modeli, keďže nie sú súčasťou definovaného analytického cieľa projektu.



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



Z pôvodného ERD som vytvorila Star schému, ktorá obsahuje 1 tabuľku faktov:
* `fact_company_events` - jednotlivé firemné udalosti a odvodené metriky
  - fact_id - primárny kľúč
  - company_id, event_type_id, date_id, time_id - cudzie kľúče
  - event_count – počet udalostí (hodnota 1 pre každý záznam), používaná na agregácie
  - events_per_year – počet udalostí spoločnosti za daný rok (vypočítané pomocou window function `COUNT(*) OVER`)
  - days_since_prev_event – počet dní od predchádzajúcej udalosti danej spoločnosti (vypočítané pomocou window function `LAG() OVER`)

    
napojenú na 4 dimenzie:
* `dim_event_type` - klasifikačné informácie o type udalosti (typ transkriptu, fiškálneho obdobie)
  - SCD typ 1: zmeny v klasifikácii udalostí sa prepisujú bez zachovania histórie, keďže historická verzia klasifikácie nie je analyticky relevantná
* `dim_company` - základné identifikačné informácie o spoločnostiach, ako je názov, úroveň entity, identifikátory
  - SCD typ 2: zmeny v atribútoch spoločnosti (napr. zmena primárnej burzy, tickra alebo úrovne entity) sú historicky významné, preto sa uchovávajú nové záznamy s platnosťou v čase
* `dim_date` - informácie o dátumoch udalostí (od roku až po deň v týždni)
  - SCD typ 0: hodnoty v dimenzii dátumu sú nemenné a nikdy sa neaktualizujú
* `dim_time` - informácie o čase udalostí (od konkrétneho času až po sekundu)
  - SCD typ 0: hodnoty v dimenzii času sú nemenné a nikdy sa neaktualizujú

Samotná štruktúra hviezdicovej schémy je znázornená na diagrame nižšie, kde môžeme pozorovať jednotlivé vzťahy a prepojenia medzi tabuľkami. Môžeme si taktiež všimnúť, že niektoré údaje z pôvodnej ERD scény sme vynechali, keďže nie sú relevantné pre našu analýzu udalostí a zlepší sa tak prehľadnosť.

<p align="center">
  <img width="803" height="593" alt="Star_schema_Company" src="https://github.com/user-attachments/assets/bc2c3904-8720-49fa-88b9-b5887ff22a8b" />
  <br>
  <em>Obrázok 2 – Star schéma pre Company dataset</em>
</p>

<br>

## **3. ELT proces v Snowflake**

ETL proces pozostáva z troch hlavných častí:
- E - Extract - extrahovanie dát
- L - Load - načítanie dát
- T - Transform - transformácia dát

Tento proces bol implementovaný v Snowflake s cieľom pripraviť zdrojové dáta zo staging vrstvy do viacdimenzionálneho modelu vhodného na analýzu a vizualizáciu.

<br>

### **3.1 Extract**

woof





