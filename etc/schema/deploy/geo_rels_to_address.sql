-- Deploy geo_rels_to_address

BEGIN;

    insert into object_type (name) values
          ('timezone')
        , ('continent')
        , ('currency')
        , ('country')
        , ('city')
        , ('postal_code')
    ;

COMMIT;
BEGIN;

    insert into city (name,name_ascii,country,admin1,fcode,state,timezone) values ('Queens','Queens',234,'NY','PPL',3623,153);
    update postal_code set state = 3601 where postal_code = '66101';
    update postal_code set state = 3601 where postal_code = '66968';

COMMIT;
BEGIN;
    update postal_code set state = 3596 where postal_code in ('71601','71602','71603','71611','71612','71613','71630','71631','71635','71638','71639','71640','71642','71643','71644','71646','71647','71651','71652','71653','71654','71655','71656','71657','71658','71659','71660','71661','71662','71663','71665','71666','71667','71670','71671','71674','71675','71676','71677','71678','71701','71711','71720','71721','71722','71724','71725','71726','71728','71730','71731','71740','71742','71743','71744','71745','71747','71748','71749','71750','71751','71752','71753','71754','71758','71759','71762','71763','71764','71765','71766','71768','71770','71772','71801','71802','71820','71822','71823','71825','71826','71827','71828','71831','71832','71833','71834','71835','71836','71837','71838','71839','71840','71841','71842','71844','71845','71846','71847','71851','71852','71853','71854','71855','71857','71858','71859','71860','71861','71862','71864','71865','71866','71901','71902','71903','71909','71910','71913','71914','71920','71921','71922','71923','71929','71932','71933','71935','71937','71940','71941','71942','71943','71944','71945','71949','71950','71951','71952','71953','71956','71957','71958','71959','71960','71961','71962','71964','71965','71966','71968','71969','71970','71971','71972','71973','71998','71999','72001','72002','72003','72004','72005','72006','72007','72010','72011','72012','72013','72014','72015','72016','72017','72018','72019','72020','72021','72022','72023','72024','72025','72026','72027','72028','72029','72030','72031','72032','72033','72034','72035','72036','72037','72038','72039','72040','72041','72042','72043','72044','72045','72046','72047','72048','72051','72052','72053','72055','72057','72058','72059','72060','72061','72063','72064','72065','72066','72067','72068','72069','72070','72072','72073','72074','72075','72076','72078','72079','72080','72081','72082','72083','72084','72085','72086','72087','72088','72089','72099','72101','72102','72103','72104','72105','72106','72107','72108','72110','72111','72112','72113','72114','72115','72116','72117','72118','72119','72120','72121','72122','72123','72124','72125','72126','72127','72128','72129','72130','72131','72132','72133','72134','72135','72136','72137','72139','72140','72141','72142','72143','72145','72149','72150','72152','72153','72156','72157','72158','72160','72164','72165','72166','72167','72168','72169','72170','72173','72175','72176','72178','72179','72180','72181','72182','72183','72189','72190','72198','72199','72201','72202','72203','72204','72205','72206','72207','72209','72210','72211','72212','72214','72215','72216','72217','72219','72221','72222','72223','72225','72227','72231','72260','72295','72301','72303','72310','72311','72312','72313','72315','72316','72319','72320','72321','72322','72324','72325','72326','72327','72328','72329','72330','72331','72332','72333','72335','72336','72338','72339','72340','72341','72342','72346','72347','72348','72350','72351','72352','72353','72354','72355','72358','72359','72360','72364','72365','72366','72367','72368','72369','72370','72372','72373','72374','72376','72377','72379','72383','72384','72386','72387','72389','72390','72391','72392','72394','72395','72396','72401','72402','72403','72404','72410','72411','72412','72413','72414','72415','72416','72417','72419','72421','72422','72424','72425','72426','72427','72428','72429','72430','72431','72432','72433','72434','72435','72436','72437','72438','72439','72440','72441','72442','72443','72444','72445','72447','72449','72450','72451','72453','72454','72455','72456','72457','72458','72459','72460','72461','72462','72464','72465','72466','72467','72469','72470','72471','72472','72473','72474','72475','72476','72478','72479','72482','72501','72503','72512','72513','72515','72517','72519','72520','72521','72522','72523','72524','72525','72526','72527','72528','72529','72530','72531','72532','72533','72534','72536','72537','72538','72539','72540','72542','72543','72544','72545','72546','72550','72553','72554','72555','72556','72560','72561','72562','72564','72565','72566','72567','72568','72569','72571','72572','72573','72575','72576','72577','72578','72579','72581','72583','72584','72585','72587','72601','72602','72611','72613','72615','72616','72617','72619','72623','72624','72626','72628','72629','72630','72631','72632','72633','72634','72635','72636','72638','72639','72640','72641','72642','72644','72645','72648','72650','72651','72653','72654','72655','72657','72658','72659','72660','72661','72662','72663','72666','72668','72669','72670','72672','72675','72677','72679','72680','72682','72683','72685','72686','72687','72701','72702','72703','72704','72711','72712','72714','72715','72716','72717','72718','72719','72721','72722','72727','72728','72729','72730','72732','72733','72734','72735','72736','72737','72738','72739','72740','72741','72742','72744','72745','72747','72749','72751','72752','72753','72756','72757','72758','72760','72761','72762','72764','72765','72766','72768','72769','72770','72773','72774','72776','72801','72802','72811','72812','72820','72821','72823','72824','72826','72827','72828','72829','72830','72832','72833','72834','72835','72837','72838','72839','72840','72841','72842','72843','72845','72846','72847','72851','72852','72853','72854','72855','72856','72857','72858','72860','72863','72865','72901','72902','72903','72904','72905','72906','72908','72913','72914','72916','72917','72918','72919','72921','72923','72926','72927','72928','72930','72932','72933','72934','72935','72936','72937','72938','72940','72941','72943','72944','72945','72946','72947','72948','72949','72950','72951','72952','72955','72956','72957','72958','72959');

    update postal_code set state = 3601 where postal_code in ('66002','66006','66007','66008','66010','66012','66013','66014','66015','66016','66017','66018','66019','66020','66021','66023','66024','66025','66026','66027','66030','66031','66032','66033','66035','66036','66039','66040','66041','66042','66043','66044','66045','66046','66047','66048','66049','66050','66051','66052','66053','66054','66056','66058','66060','66061','66062','66063','66064','66066','66067','66070','66071','66072','66073','66075','66076','66077','66078','66079','66080','66083','66085','66086','66087','66088','66090','66091','66092','66093','66094','66095','66097','66101','66102','66103','66104','66105','66106','66109','66110','66111','66112','66113','66115','66117','66118','66119','66160','66201','66202','66203','66204','66205','66206','66207','66208','66209','66210','66211','66212','66213','66214','66215','66216','66217','66218','66219','66220','66221','66222','66223','66224','66225','66226','66227','66250','66251','66276','66279','66282','66283','66285','66286','66401','66402','66403','66404','66406','66407','66408','66409','66411','66412','66413','66414','66415','66416','66417','66418','66419','66420','66422','66423','66424','66425','66426','66427','66428','66429','66431','66432','66434','66436','66438','66439','66440','66441','66442','66449','66451','66501','66502','66503','66505','66506','66507','66508','66509','66510','66512','66514','66515','66516','66517','66518','66520','66521','66522','66523','66524','66526','66527','66528','66531','66532','66533','66534','66535','66536','66537','66538','66539','66540','66541','66542','66543','66544','66546','66547','66548','66549','66550','66552','66554','66601','66603','66604','66605','66606','66607','66608','66609','66610','66611','66612','66614','66615','66616','66617','66618','66619','66620','66621','66622','66624','66625','66626','66628','66629','66636','66637','66642','66647','66652','66653','66667','66675','66683','66692','66699','66701','66710','66711','66712','66713','66714','66716','66717','66720','66724','66725','66728','66732','66733','66734','66735','66736','66738','66739','66740','66741','66742','66743','66746','66748','66749','66751','66753','66754','66755','66756','66757','66758','66759','66760','66761','66762','66763','66767','66769','66770','66771','66772','66773','66775','66776','66777','66778','66779','66780','66781','66782','66783','66801','66830','66833','66834','66835','66838','66839','66840','66842','66843','66845','66846','66849','66850','66851','66852','66853','66854','66855','66856','66857','66858','66859','66860','66861','66862','66863','66864','66865','66866','66868','66869','66870','66871','66872','66873','66901','66930','66932','66933','66935','66936','66937','66938','66939','66940','66941','66942','66943','66944','66945','66946','66948','66949','66951','66952','66953','66955','66956','66958','66959','66960','66961','66962','66963','66964','66966','66967','66968','66970','67001','67002','67003','67004','67005','67008','67009','67010','67012','67013','67016','67017','67018','67019','67020','67021','67022','67023','67024','67025','67026','67028','67029','67030','67031','67035','67036','67037','67038','67039','67041','67042','67045','67047','67049','67050','67051','67052','67053','67054','67055','67056','67057','67058','67059','67060','67061','67062','67063','67065','67066','67067','67068','67070','67071','67072','67073','67074','67101','67102','67103','67104','67105','67106','67107','67108','67109','67110','67111','67112','67114','67117','67118','67119','67120','67122','67123','67124','67127','67131','67132','67133','67134','67135','67137','67138','67140','67142','67143','67144','67146','67147','67149','67150','67151','67152','67154','67155','67156','67159','67201','67202','67203','67204','67205','67206','67207','67208','67209','67210','67211','67212','67213','67214','67215','67216','67217','67218','67219','67220','67221','67223','67226','67227','67228','67230','67232','67235','67260','67275','67276','67277','67278','67301','67330','67332','67333','67334','67335','67336','67337','67340','67341','67342','67344','67345','67346','67347','67349','67351','67352','67353','67354','67355','67356','67357','67360','67361','67363','67364','67401','67402','67410','67416','67417','67418','67420','67422','67423','67425','67427','67428','67430','67431','67432','67436','67437','67438','67439','67441','67442','67443','67444','67445','67446','67447','67448','67449','67450','67451','67452','67454','67455','67456','67457','67458','67459','67460','67464','67466','67467','67468','67470','67473','67474','67475','67476','67478','67480','67481','67482','67483','67484','67485','67487','67490','67491','67492','67501','67502','67504','67505','67510','67511','67512','67513','67514','67515','67516','67518','67519','67520','67521','67522','67523','67524','67525','67526','67529','67530','67543','67544','67545','67546','67547','67548','67550','67552','67553','67554','67556','67557','67559','67560','67561','67563','67564','67565','67566','67567','67568','67570','67572','67573','67574','67575','67576','67578','67579','67581','67583','67584','67585','67601','67621','67622','67623','67625','67626','67627','67628','67629','67631','67632','67634','67635','67637','67638','67639','67640','67642','67643','67644','67645','67646','67647','67648','67649','67650','67651','67653','67654','67656','67657','67658','67659','67660','67661','67663','67664','67665','67667','67669','67671','67672','67673','67674','67675','67701','67730','67731','67732','67733','67734','67735','67736','67737','67738','67739','67740','67741','67743','67744','67745','67747','67748','67749','67751','67752','67753','67756','67757','67758','67761','67762','67764','67801','67831','67834','67835','67836','67837','67838','67839','67840','67841','67842','67843','67844','67846','67849','67850','67851','67853','67854','67855','67857','67859','67860','67861','67862','67863','67864','67865','67867','67868','67869','67870','67871','67876','67877','67878','67879','67880','67882','67901','67905','67950','67951','67952','67953');

COMMIT;
BEGIN;
    delete from address where id in (1706, 1710, 1712, 1727, 1728, 1729, 1730, 1731, 13300, 13302, 17228, 35611, 35612, 35613,505,506, 22384, 8023, 22387, 7817, 7689, 7101, 6645, 7882, 461, 7868) or street_address = 'NA';

COMMIT;
BEGIN;
    update address set postal_code = null where postal_code = '00000' or postal_code = '99999';
    update address set city = 'Saint Cloud', state = 'ON', country = 'CA' where id in (15888,8450);
    update address set city = 'Waterloo', state = 'ON', country = 'CA' where id = 5314;
    update address set city = 'Welland', state = 'ON', country = 'CA' where id = 5275;
    update address set city = 'London', state = 'ON', country = 'CA' where id = 5251;
    update address set city = 'Rotterdam', country = 'NL' where id = 7831;
    update address set city = 'Mumbai', country = 'IN' where id = 7813;
    UPDATE address set city = 'Dartmouth', state = 'NS' where id = 1234;
    UPDATE address set city = 'Chertsey', country = 'GB' where id = 1259;
    UPDATE address set city = 'Madrid', country = 'ES' where id in (1521,22574);
    UPDATE address set city = 'Amsterdam', country = 'NL' where id IN (1634, 1856);
    UPDATE address set city = 'Avondale', country = 'NZ' where id = 1645;
    update address set city = 'Vienna', country = 'AT' where id IN (1656,1849);
    update address set city = 'Moscow',country = 'RU' where id = 1828;
    update address set city = 'Buenos Aires', country = 'AR' where id = 1832;
    update address set city = 'London', country = 'GB' where id in (1838, 1868, 1874,7323);
    update address set city = 'Stockholm', country = 'SE' where id = 1839;
    update address set city = 'Prague', country = 'CZ' where id = 1840;
    update address set city = 'Tallinn', country = 'EE' where id = 1843;
    update address set city = 'Budapest', country = 'HU' where id = 1844;
    update address set city = 'Copenhagen', country = 'DK' where id = 1845;
    update address set city = 'Rome', country = 'IT' where id = 1855;
    update address set city = 'Outremont', country = 'CA' where id = 1857;
    update address set city = 'Neuilly-sur-Seine', country = 'FR' where id = 1859;
    update address set city = 'Munich', country = 'DE' where id in (1862, 1867);
    update address set city = 'Iver', country = 'GB' where id = 1860;
    update address set city = 'Paris', country = 'FR' where id in (1863, 1866,22375);
    update address set city = 'Tokyo', country = 'JP' where id = 1869;
    update address set city = 'Warsaw', country = 'PL' where id = 1870;
    update address set city = 'Bratislava', country = 'SK' where id = 1871;
    update address set city = 'Brussels', country = 'BE' where id in (1864, 1873);
    update address set city = 'Bern', country = 'CH' where id = 1858;
    update address set city = 'Bonn', country = 'DE' where id = 1865;
    update address set city = 'Lachine', country = 'CA', state = 'QC' where id = 3172;
    update address set city = 'Toronto', country = 'CA', state = 'ON' where id = 3318;
    update address set city = 'Nyon', country = 'CH' where id = 3371;
    update address set city = 'Vancouver', country = 'CA', state = 'BC' where id in (3467, 5007);
    update address set city = 'North York', country = 'CA', state = 'ON' where id in (3468,5006);
    update address set city = 'Charlesbourg', country = 'CA', state = 'QC' where id = 3489;
    update address set city = 'Montreal', country = 'CA', state = 'QC' where id in (3491, 34491);
    update address set city = 'Stuttgart', country = 'DE' where id = 3891;
    update address set country = 'DE' where city ilike 'GERMANY';
    update address set city = 'Berlin', country = 'DE' where id = 3994;
    update address set city = 'Saint Johns', country = 'CA', state = 'NF' where id = 5015;
    update address set city = 'Scarborough', country = 'CA', state = 'ON' where id = 5016;
    update address set city = 'Nice', country = 'FR' where id = 12844;
    update address set city = 'New Delhi', country = 'IN' where id = 3992;
    update address set city = 'Rio de Janeiro', country = 'BR' where id = 1561;
    update address set country = 'GB' where UPPER(city) = 'LONDON' and country is null or country = 'UK';
    update address set country = 'MX', city = 'Mexico City' where city = 'Mexico' and country is null;
    update address set country = 'GB', city = 'London' where city = 'England';
    update address set country = 'PA', city = 'Panama City' where UPPER(city) = 'PANAMA';
    update address set city = 'Saint John', country = 'CA' where UPPER(city) like 'ST. JOHN,%' or UPPER(city) like 'ST JOHN,%';
    update address set city = 'Saint Johns', country = 'CA' where UPPER(city) like 'ST. JOHNS,%' or UPPER(city) = 'ST JOHNS';
    update address set country = 'CA' where UPPER(city) = 'NIAGARA FALLS';
    update address set country = 'CA' where upper(city) = 'ONTARIO';
    update address set country = 'GB' where upper(city) = 'CORNWALL';
    update address set country = 'FR' where upper(city) = 'PARIS';
    UPDATE address set country = 'ES' where UPPER(city) = 'MADRID';
    update address set city = 'Saint-Laurent', country = 'CA' where city = 'Saint Laurent QC';
    update address set city = 'Surrey', country = 'CA', state = 'BC' where city = 'Surry BC';
    update address set city = 'Warsaw', country = 'PL' where city = 'WARSAW POLLAND';
    update address set city = 'Montreal', country = 'CA', state = 'QC' where UPPER(city) = E'VILLE D\'ANJOU';
    update address set city = 'Buenos Aires', country = 'AR' where city = 'CIUDAD AUTONOMA BUENOS';
    update address set city = 'Mexico City', country = 'MX' where city = 'MEXICO DF' or city = 'MEXICO D F';
    update address set city = 'Mexico City', country = 'MX' where id in (4676);
    update address set city = 'Middlesex', country = 'GB' where city = 'MIDDSEX';
    update address set city = 'Washington, D. C.', country = 'US' where city = 'WASHINGTON DC';
    update address set city = 'Saint Albert', country = 'CA' where city = 'ST ALBERT';
    update address set city = 'Burlington', country = 'CA', state = 'ON' where id in (1457,2769);
    update address set city = 'Dublin', country = 'IE' where id = 7124;
    update address set city = 'Vancouver', country = 'CA', state = 'BC' where id in (7903, 7993,22385,933);
    update address set city = 'Markham', country = 'CA', state = 'ON' where upper(city) = 'MARKHAM';
    update address set city = 'Halifax', country = 'CA', state = 'NS' where upper(city) = 'HALIFAX';
    update address set city = 'Edmonton', country = 'CA', state = 'AB' where upper(city) = 'EDMONTON';
    update address set city = 'Summerside', country = 'CA' where upper(city) like 'SUMMERSIDE%';
    update address set city = 'Oakville', country = 'CA' where upper(city) = 'Oakville';
    update address set city = 'Washington, D. C.', country = 'US' where id = 8413;
    update address set city = 'Geneve', country = 'CH' where id = 1468;
    update address set city = 'Durban', country = 'ZA' where id in (7988,7771);
    update address set city = 'Brights Grove', country = 'CA', state = 'ON' where id = 2702;
    update address set city = 'Riverbank', country = 'CA', state = 'NB' where id = 2682;
    update address set city = 'Sydney', country = 'CA', state = 'NS' where id = 2767;
    update address set country = 'CA', state = 'BC' where id = 2755;
    update address set country = 'VI' where id = 580;
    update address set city = 'Washington, D. C.' where city ilike '%Washing%' and state = 'DC' and country = 'US';
    update address set city = 'Washington, D. C.' where postal_code = '20005' or state = 'DC';
    update address set city = 'New York City' where postal_code = '11238';
    update address set city = 'Pontiac' where postal_code = '48302';
    update address set city = 'Hyattsville' where postal_code = '20785';
    update address set city = 'Denver' where postal_code = '80202';
    update address set city = 'Peoria' where postal_code = '61603';
    update address set city = 'Orlando' where postal_code = '32803';
    update address set city = 'San Mateo' where postal_code = '94403';
    update address set city = 'Vancouver' where postal_code = '98684';
    update address set city = 'Veradale' where postal_code = '99037';
    update address set city = 'New York City' where postal_code = '10018';
    update address set city = 'Dallas' where postal_code = '75235';
    update address set city = 'Madison Heights' where postal_code = '48071';
    update address set city = 'Seattle' where postal_code = '98103';
    update address set city = 'Atlanta' where city ilike '%altanta%' and state = 'GA' and country = 'US';
    update address set city = 'New York City' where city ilike 'New Yor%' and state = 'NY' and country = 'US';
    update address set city = 'New York City' where city ilike 'New Yro%' and state = 'NY' and country = 'US';
    update address set city = 'New York City' where city ilike 'NY%' and state = 'NY' and country = 'US';
    update address set city = 'New York City' where city ilike 'New York' and state = 'NY' and country = 'US';
    update address set city = 'Los Angeles' where city ilike 'Los Ang%' and state = 'CA' and country = 'US';
    update address set city = 'Atlantic City' where city ilike 'ALTANTIC CITY' and state = 'NJ' and country = 'US';
    update address set city = 'Ypsilanti' where city ilike 'Ypsilonti' and state = 'MI' and country = 'US';
    update address set city = 'Mira Loma' where postal_code = '91752';
    update address set city = 'Pittston' where postal_code = '18643';
    update address set city = 'New Caney' where postal_code = '77357';
    update address set city = 'Parsons' where postal_code = '26287';
    update address set city = 'Yonkers' where city = 'Yonker' and state = 'NY';
    update address set city = 'Wichita' where city ilike 'WITCHITA' and state = 'KS';
    update address set city = 'New York City' where postal_code = '10006' and state = 'NY';
    update address set city = 'Bloomfield Hills' where postal_code = '48302' and state = 'MI';
    update address set city = 'Chicago' where city ilike 'Chicag' and state = 'IL';
    update address set city = 'Easthampton' where city ilike 'Eastampton' and state = 'NJ';
    update address set city = 'East Saint Louis' where (city ilike 'East St Louis' OR city ilike 'E St Louis') and state = 'IL';
    update address set city = 'El Paso' where city ilike 'Elpaso' and state = 'TX';
    update address set city = 'Fairbank' where city ilike 'FARIBANK' and state = 'IA';
    update address set city = 'Fort Washington' where city ilike 'FORT WASINGTON';
    update address set city = 'Phoenix' where postal_code = '85014' and country = 'US';
    update address set city = 'Peoria' where city ilike 'PEOIRA' and country = 'US';
    update address set city = 'Phoenix' where city ilike 'Pheonix' and country = 'US';
    update address set city = 'Phoenix' where city ilike 'PHOENIZ' and state = 'AZ';
    update address set city = 'Philadelphia' where city ilike 'Phila%' and state = 'PA' and country = 'US';
    update address set city = 'Portland' where city ilike 'PORLTAND' and country = 'US';
    update address set city = 'Poughkeepsie' where city ilike 'POUGKEEPSIE' and country = 'US';
    update address set city = 'Princeton' where city ilike 'PRNCETON' and country = 'US';
    update address set city = 'Salt Lake City' where city ilike 'SALT LAKE%' and country = 'US';
    update address set city = 'San Diego' where (city ilike 'SAN DEIGO' or city ilike 'SAN  DIEGO') and country = 'US';
    update address set city = 'San Francisco' where city ilike 'SAN FRANCIXCO' and country = 'US';
    update address set city = 'Santa Cruz' where city ilike 'SANTA CURZ' and country = 'US';
    update address set city = 'Seattle' where (city ilike 'SEA-TAC' or city ilike 'SEATLE' or city ilike 'SEATLLE') and country = 'US';
    update address set city = 'Terre Haute' where city ilike 'TERRE HOUTE' and country = 'US';
    update address set city = 'Tallahassee' where (city ilike 'TALLAHASEE' or city ilike 'TALLAHASSE') and country = 'US';
    update address set city = 'Saint Louis' where (city ilike 'ST LOUIS' or city ilike 'ST LOUIS,' or city ilike 'ST.LOUIS' or city ilike 'ST.  LOUIS') and country = 'US';
    update address set city = 'McLean' where (city ilike 'Mc Lean' or city ilike 'Maclean') and country = 'US' and state = 'VA';
    update address set city = 'Fort Worth' where city ilike 'Forth Worth' and country = 'US';
    update address set city = 'The Bronx' where city ilike 'bronx' and country = 'US' and state = 'NY';
    update address set city = 'Queens' where (city ilike 'queens' or city ilike 'flushing' or city ilike 'ozone park') and country = 'US' and state = 'NY';
    update address set city = 'Sainte Genevieve' where city ilike '%Genevieve' and state = 'MO' and country = 'US';
    update address set city = 'Philadelphia' where city ilike 'Ph%delphia' and state = 'PA' and country = 'US';
    update address set city = 'Sacramento' where city ilike 'Sac%mento' and state = 'CA' and country = 'US';
    update address set city = 'Pittsburgh' where city ilike 'Pittsbrugh' and state = 'PA' and country = 'US';

COMMIT;
BEGIN;
    -- remove country for addresses with bad country
    update address set country = null where UPPER(state) not in ('PA','AZ','FL','MT','LA','NM','AK','NC','OR','VT','MS','AR','VA','SD','IL','TN','MO','NH','HI','IN','IA','WY','SC','UT','NY','MI','MA','KS','ID','NJ','TX','MD','GA','WI','MN','DC','OH','NE','CT','NV','OK','AL','ND','CO','CA','WV','DE','KY','WA','ME','RI');

    update address set state = (select abbreviation from state where name = 'Ontario'), country = 'CA' where state = 'ZZ';

COMMIT;
BEGIN;

    -- update some addresses with bad states and countries first
    -- anything other than a CTE is crazy slow here.
    WITH new_values AS (
        SELECT distinct on (a.id) a.id
             , s.id AS state
             , COALESCE(c.id,c2.id,c3.id,c4.id) AS country
             , pc.id AS postal_code
             , COALESCE(ci2.id,ci.id) as city
        FROM address a
             JOIN postal_code pc
                ON substr(a.postal_code, 1, 5) = pc.postal_code
             JOIN country c
                ON pc.country = c.id
             JOIN state s
                ON pc.state = s.id
             LEFT JOIN country c2
                ON s.country = c2.id
             LEFT JOIN city ci2
                ON (
                    a.city ilike '%'||ci2.name||'%'
                 OR a.city ilike '%'||ci2.alternate_names||'%'
                )
               AND ci2.country = 234
               AND ci2.alternate_names is not null
             LEFT JOIN country c3
                ON ci2.country = c3.id
             LEFT JOIN city ci
                ON (
                    replace(replace(replace(replace(replace(UPPER(a.city), '.',''), 'FT ', 'FORT '), 'MT ', 'MOUNT '), 'ST ', 'SAINT '), ',','') ilike '%'||ci.name_ascii||'%'
                 OR replace(replace(replace(replace(replace(UPPER(a.city), '.',''), 'FT ', 'FORT '), 'MT ', 'MOUNT '), 'ST ', 'SAINT '), ',','') ilike '%'||ci.alternate_names||'%'
                )
               AND ci.country = 234
               AND ci.state = s.id
             LEFT JOIN country c4
                ON ci.country = c4.id
        WHERE c.iso_alpha2 = 'US'
          AND s.country = c.id
        AND UPPER(a.state) IN (
            'PA','AZ','FL','MT','LA','NM','AK','NC','OR','VT','MS','AR','VA','SD','IL','TN','MO','NH','HI','IN','IA','WY','SC','UT','NY','MI','MA','KS','ID','NJ','TX','MD','GA','WI','MN','DC','OH','NE','CT','NV','OK','AL','ND','CO','CA','WV','DE','KY','WA','ME','RI'
        )
    )
    UPDATE address AS a
        SET state = nv.state,
            country = nv.country,
            postal_code = nv.postal_code,
            city = nv.city
        FROM new_values nv
        WHERE nv.id = a.id
    ;

COMMIT;
BEGIN;

    -- guam
    WITH new_values AS (
        SELECT  distinct on(a.id) a.id,
                s.id AS state,
                COALESCE(c.id,c2.id) AS country,
                ci.id AS city,
                pc.id as postal_code
        FROM address a
            JOIN country c
                ON a.state = c.iso_alpha2
            JOIN state s
                ON s.name_ascii ilike '%' || a.city || '%'
               AND s.country = 92
            JOIN city ci
                ON ci.name_ascii ilike '%'||a.city||'%'
               AND ci.country = 92
            JOIN postal_code pc
                ON pc.postal_code = a.postal_code
               AND pc.country = 92
             LEFT JOIN country c2
                ON s.country = c2.id
        WHERE a.state = 'GU'
    )
    UPDATE address AS a
        SET country = nv.country,
            state = nv.state,
            city = nv.city,
            postal_code = nv.postal_code
        FROM new_values nv
        WHERE nv.id = a.id
    ;

COMMIT;
BEGIN;

    -- fill in Puerto Rico
    update address set city = 'Rio Piedras' where city = 'ROI PIEDRAS';
    update address set city = 'Puerto Nuevo' where UPPER(city) like 'PUERTO NUEVO%';
    update address set state = 'PR', city = 'San Juan' WHERE UPPER(city) IN ('RIO PIEDRAS','SANTURCE','PUERTO NUEVO');
    update address set state = 'PR' where UPPER(city) IN ('PONCE','SAN JUAN');

    WITH new_values AS (
        SELECT DISTINCT ON(a.id)
               a.id
             , pc.id as postal_code
             , COALESCE(c.id,c2.id) as country
             , s.id AS state
             , ci.id as city
        FROM address a
            LEFT JOIN postal_code pc
                ON substr(a.postal_code, 1, 5) = pc.postal_code
               AND pc.country = 183
            LEFT JOIN country c
                ON pc.country = c.id
               AND pc.country = 183
            LEFT JOIN state s
                ON (
                    UPPER(s.name_ascii) ilike '%'||UPPER(a.city)||'%'
                 OR UPPER(s.alternate_names) ilike '%'||UPPER(a.city)||'%'
                )
               AND s.country = 183
            LEFT JOIN city ci
                ON (
                    ci.name_ascii ilike '%'||a.city||'%'
                 OR ci.alternate_names ilike '%'||a.city||'%'
                )
               AND ci.country = 183
            LEFT JOIN country c2
                ON ci.country = c2.id
        WHERE UPPER(a.state) NOT IN (
            'PA','AZ','FL','MT','LA','NM','AK','NC','OR','VT','MS','AR','VA','SD','IL','TN','MO','NH','HI','IN','IA','WY','SC','UT','NY','MI','MA','KS','ID','NJ','TX','MD','GA','WI','MN','DC','OH','NE','CT','NV','OK','AL','ND','CO','CA','WV','DE','KY','WA','ME','RI'
        )
            AND a.state = 'PR'
    )
    UPDATE address AS a
        SET state = nv.state,
            country = nv.country,
            postal_code = nv.postal_code,
            city = nv.city
        FROM new_values nv
        WHERE nv.id = a.id
    ;

COMMIT;
BEGIN;


    -- reform canadian addresses
    update address set city = 'Surrey, BC', state = 'BC' where city = 'Surry, BC';
    update address set state = 'ON', postal_code = 'L0B' where city = 'NESTLETON, ON';
    update address set state = 'ON', postal_code = 'N8N' where city = 'Tecumseh, ON';
    update address set state = 'ON', postal_code = 'K0M 1L0' where city = 'Dunsford, ON';
    update address set city = 'Alfred and Plantagenet', state = 'ON', postal_code = 'K0B' where city = 'PLANTAGENET, ON';
    update address set city = 'Vancouver', state = 'BC', postal_code = 'V6G 2V4' where city = 'Vancouover, BC V6G 2V4';
    update address set city = 'Gabriola Island', state = 'BC', postal_code = 'V0R 1X0' where city = 'Gabriola, BC V0R 1X0';
    insert into city (name,name_ascii,country,admin1,fcode,state,timezone) values ('Gabriola Island','Gabriola Island',38,'BC','PPL',466,196);
    insert into city (name,name_ascii,country,admin1,fcode,state,timezone) values ('Tecumseh','Tecumseh',38,'ON','PPL',472,194);
    insert into city (name,name_ascii,country,admin1,fcode,state,timezone) values ('Dunsford','Dunsford',38,'ON','PPL',472,194);
    insert into city (name,name_ascii,country,admin1,fcode,state,timezone) values ('Nestleton','Nestleton',38,'ON','PPL',472,194);
    insert into city (name,name_ascii,country,admin1,fcode,state,timezone) values ('Alfred and Plantagenet','Alfred and Plantagenet',38,'ON','PPL',472,194);
    insert into city (name,name_ascii,country,admin1,fcode,state,timezone) values ('Pointe-Aux Trembles','Pointe-Aux Trembles',38,'QC','PPL',474,150);
COMMIT;
BEGIN;

    WITH new_values AS (
        SELECT DISTINCT ON (a.id)
            a.id
          , c.id as city
          , COALESCE(s.id,s2.id) as state
          , COALESCE(co.id,co2.id) as country
          , pc.id as postal_code
        FROM address a
        LEFT JOIN city c
            ON a.city ILIKE '%' || c.name_ascii || '%'
                AND c.country = 38
        LEFT JOIN postal_code pc
            ON substr(a.postal_code, 1,3) = pc.postal_code
                AND pc.country = 38
        LEFT JOIN state s
            ON pc.state = s.id
        LEFT JOIN state s2
            ON c.state = s2.id
        LEFT JOIN country co
            ON s.country = co.id
        LEFT JOIN country co2
            ON s2.country = co2.id
    WHERE UPPER(a.state) NOT IN (
        'PA','AZ','FL','MT','LA','NM','AK','NC','OR','VT','MS','AR','VA','SD','IL','TN','MO','NH','HI','IN','IA','WY','SC','UT','NY','MI','MA','KS','ID','NJ','TX','MD','GA','WI','MN','DC','OH','NE','CT','NV','OK','AL','ND','CO','CA','WV','DE','KY','WA','ME','RI'
    )
        AND (
               a.state IN ('BC','ON','QC')
            OR UPPER(city) LIKE '%TORONTO%'
            OR UPPER(city) LIKE '%OTTAWA%'
            OR UPPER(city) LIKE '%CALGARY%'
            OR UPPER(city) LIKE '%WINNIPEG%'
            OR UPPER(city) LIKE '%QUEBEC%'
            OR UPPER(city) LIKE '%AJAX%'
            OR UPPER(city) LIKE '%MONTREAL%'
            OR UPPER(city) LIKE '%, ON'
            OR UPPER(city) LIKE '%, MB%'
            OR UPPER(city) LIKE '%, QC%'
            OR UPPER(city) LIKE '%, BC%'
            OR UPPER(city) LIKE '%, AB%'
            OR upper(city) LIKE '%, SK%'
        )
    )
    UPDATE address AS a
        SET state = nv.state,
            country = nv.country,
            city = nv.city,
            postal_code = nv.postal_code
        FROM new_values nv
        WHERE nv.id = a.id
    ;
    update address set postal_code = null where country = 'CA' and postal_code in ('00000','99999');

COMMIT;
BEGIN;

    -- update remaining addresses in US states
    WITH new_values AS (
        SELECT DISTINCT ON (a.id)
          a.id
        , coalesce(s1.id,s2.id) AS state
        , c.id AS city
        , pc.id AS postal_code
        , co.id AS country
    FROM address a
        LEFT JOIN state s1
            ON a.state = s1.abbreviation
        LEFT JOIN city c
            ON (
                c.name_ascii ilike '%'||a.city||'%'
             OR c.alternate_names ilike '%'||a.city||'%'
            )
        LEFT JOIN state s2
            ON c.state = s2.id
        LEFT JOIN postal_code pc
            ON substr(a.postal_code, 1, 5) = pc.postal_code
        LEFT JOIN country co
            ON a.country = co.iso_alpha2
    WHERE (a.state !~ '\d+'
        OR a.country !~ '\d+'
        OR a.postal_code !~ '\d+')
        AND a.state IN (
    'PA','AZ','FL','MT','LA','NM','AK','NC','OR','VT','MS','AR','VA','SD','IL','TN','MO','NH','HI','IN','IA','WY','SC','UT','NY','MI','MA','KS','ID','NJ','TX','MD','GA','WI','MN','DC','OH','NE','CT','NV','OK','AL','ND','CO','CA','WV','DE','KY','WA','ME','RI'
        )
    )
    UPDATE address AS a
        SET state = nv.state,
            city = nv.city,
            country = nv.country,
            postal_code = nv.postal_code
        FROM new_values nv
        WHERE nv.id = a.id
    ;

    -- Fix up remaining addresses

COMMIT;
BEGIN;

    WITH new_values AS (
        SELECT DISTINCT ON(a.id)
             a.id
           , coalesce(co2.id,co3.id) AS country
           , ci1.id AS city
           , coalesce(s.id,s2.id) AS state
           , pc.id AS postal_code
        FROM address a
            LEFT JOIN city ci1
                ON CASE WHEN a.city like '%,%'
                        THEN UPPER(ci1.name_ascii) = UPPER((regexp_split_to_array(a.city, ','))[1])
                        ELSE UPPER(ci1.name_ascii) = UPPER(a.city)
                END
            LEFT JOIN country co2
                ON CASE WHEN a.country is not null
                        THEN a.country = co2.iso_alpha2
                        ELSE ci1.country = co2.id
                END
            LEFT JOIN state s
                ON ci1.state = s.id
               AND s.country = co2.id
            LEFT JOIN postal_code pc
                ON CASE WHEN length(replace(a.postal_code, ' ','')) > 5
                        THEN substr(replace(a.postal_code,' ',''), 1,3) = pc.postal_code
                        ELSE substr(replace(a.postal_code,' ',''), 1,5) = pc.postal_code
                END
            LEFT JOIN state s2
                ON pc.state = s2.id
            LEFT JOIN country co3
                ON pc.country = co3.id
        WHERE (a.state !~ '\d+'
            OR a.country !~ '\d+'
            OR a.postal_code !~ '\d+'
            OR a.country is null
        )
    )
    UPDATE address AS a
        SET
             state = nv.state
           , city = nv.city
           , country = nv.country
           , postal_code = nv.postal_code
        FROM new_values nv
        WHERE nv.id = a.id
    ;

    delete from address where state !~ '\d+' or country !~ '\d+' or postal_code !~ '\d+' or country is null;

COMMIT;
BEGIN;

    -- FINALLY DO THE ALTER TABLE
    alter table address alter column city set data type integer using (city::integer);
    alter table address alter column state set data type integer using (state::integer);
    alter table address alter column postal_code set data type integer using (postal_code::integer);
    alter table address alter column country set data type integer using (country::integer);
    ALTER TABLE address ALTER COLUMN street_address SET NOT NULL;
    ALTER TABLE address ALTER COLUMN country SET NOT NULL;

    alter table address add foreign key (city) references city(id) on delete cascade;
    alter table address add foreign key (state) references state(id) on delete cascade;
    alter table address add foreign key (postal_code) references postal_code(id) on delete cascade;
    alter table address add foreign key (country) references country(id) on delete cascade;

COMMIT;
