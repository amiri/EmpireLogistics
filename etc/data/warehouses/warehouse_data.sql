--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: walmart; Type: TABLE DATA; Schema: public; Owner: el
--

COPY walmart (id, walmart_id) FROM stdin;
1	6006
2	6094
3	6018
4	6031
5	7033
6	6021
7	6026
8	6019
9	7034
10	7035
11	6020
12	7038
13	6010
14	6054
15	6009
16	6092
17	6017
18	6035
19	6066
20	6048
21	6043
22	6069
23	6011
24	6040
25	6070
26	6030
27	6038/7052
28	6024
29	6037
30	6080/7041
31	6027
32	6039
33	6016/6139
34	6036/7027
35	6012
36	6068
37	7036
38	7026
39	7045
40	6023
41	7039
42	6025
43	TBD
44	4803/6699
45	6299
46	8230
47	6493
48	6494
49	6275
50	8229
51	6499
52	6598
53	8232
54	6495
55	6596
56	6697
57	6496
58	4792
59	8206
60	6597
61	6492
62	8231
63	6016
64	6903/8235
65	6698
66	6289
67	6050
68	6028/6044
69	9149
70	6001
71	6045
72	6032
73	6013
74	6046
75	6058
76	6002
77	4287/8098
78	9398
79	9193
80	9195
81	9196
82	9194
83	9153
84	6033
85	6067
86	4841/6076/6087/6271
87	7005
88	6000
89	7025
90	7086
91	4894
92	7054/7081
93	6052
94	6051/4751
95	6008
96	6022/7040
97	6041
98	6014/7031
99	6005
100	6029
101	Footwear Distribution Centers
102	6007
103	7019
104	6095
105	6082
106	7013
107	7023
108	6099
109	6071
110	6055
111	6059
112	7024
113	7055
114	6097
115	6057
116	7014
117	6065
118	6072
119	7018
120	6084
121	7048
122	6096
123	7012
124	7017
125	7015
126	6042
127	6047
128	7030
129	6073
130	6062
131	6064
132	7010
133	6083
134	6090
135	7016
136	7021
137	6085
138	7077
139	Perishables Distribution Centers
140	7084
141	6074
142	6077
143	6091
144	6056
145	TBD
146	TBD
147	Dry Distribution Centers
148	7047
149	4895
150	6060
151	6060
152	6061
153	7074/7078
154	7622
155	6088/4896
156	6901
157	6907
158	6909
159	6912
160	7101
161	6974
162	7100
163	7976
164	7837
165	7840
166	6956
\.


--
-- Name: walmart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: el
--

SELECT pg_catalog.setval('walmart_id_seq', 166, true);


--
-- Data for Name: warehouse; Type: TABLE DATA; Schema: public; Owner: el
--

COPY warehouse (id, name, street_address, city, state, postal_code, country, description, status, area, owner, date_opened, geometry) FROM stdin;
211	Great Lakes Distribution Center	 	Delaware	OH	43015	US	\N	\N	\N	krogers	\N	0101000020E61000007311DF8959C454C0E21BAFE53A264440
212	Kroger Distribution Center	701 Gellhorn Drive	Houston	TX	77029	US	\N	\N	\N	krogers	\N	0101000020E6100000A9893E1F65D157C0221CB3EC49C83D40
213	Kroger Distribution Center	5079 Bledsoe Road	Memphis	TN	38141	US	\N	\N	\N	krogers	\N	0101000020E6100000EA23F0879F7756C0EFFE78AF5A814140
214	Kroger Distribution Center	4524 Delp Street	Memphis	TN	38118	US	\N	\N	\N	krogers	\N	0101000020E61000009087BEBB957B56C0CB83F41439834140
215	Kroger Northern Floral Distribution Center	6893 County Road 14	West Liberty	OH	43357	US	\N	\N	\N	krogers	\N	0101000020E61000001585025BCAF054C0BD7ACB8B02224440
216	Kroger Southeastern Floral Distribution Center	136 Blakely Road	Simpsonville	SC	29680	US	\N	\N	\N	krogers	\N	0101000020E6100000B5A7E49CD89154C09B20EA3E005F4140
217	Central Bakery	2516 East 4th Avenue	Hutchinson	KS	67501	US	\N	\N	\N	krogers	\N	0101000020E61000008483BD89A17858C04AB54FC763074340
218	Dillons Distribution Center	2700 East 4th Avenue	Hutchinson	KS	67501	US	\N	\N	\N	krogers	\N	0101000020E61000009078C3C7717858C0040B163DA6074340
219	Dillons Distribution Center	21999 U.S. 54	Goddard	KS	67052	US	\N	\N	\N	krogers	\N	0101000020E6100000C922A875F66558C03BACCB84BAD44240
220	Fred Meyer Distribution Center	11506 Highway 212	Clackamas	OR	97015	US	\N	\N	\N	krogers	\N	0101000020E610000041DC30653BA35EC02D00321933B44640
221	Fred Meyer Distribution Center	2200 North Meridian	Puyallup	WA	98371	US	\N	\N	\N	krogers	\N	0101000020E6100000F5D89601E7925EC0C27EF4F2E09A4740
222	Fred Meyer Distribution Center	222 Maurin Road	Chehalis	WA	98532	US	\N	\N	\N	krogers	\N	0101000020E610000055DAE21A9FBA5EC09F8F32E202504740
223	Ralphs Distribution Center	2201 South Wilmington Avenue	Compton	CA	90220	US	\N	\N	\N	krogers	\N	0101000020E610000086A460D7408F5DC0FE90C88855EF4040
224	Ralphs Distribution Center	4841 West San Fernando Road	Northeast Los Angeles	CA	90039	US	\N	\N	\N	krogers	\N	0101000020E6100000729D90E744915DC0B30B06D7DC114140
225	Ralphs Distribution Center	1500 Eastridge Avenue	Riverside	CA	92507	US	\N	\N	\N	krogers	\N	0101000020E6100000DCE8ADCBBA535DC0B669C76878F74040
226	Ralphs Distribution Center	14900 Garfield Avenue	Paramount	CA	90723	US	\N	\N	\N	krogers	\N	0101000020E61000008B6CE7FBA98A5DC07D5EF1D423F34040
227	Peyton's Midsouth Distribution Center	120 Kirby Drive	Portland	TN	37148	US	\N	\N	\N	krogers	\N	0101000020E6100000B8020AF5F4A155C019575C1C954D4240
228	Peyton's Southeastern Distribution Center	153 Refreshment Lane Southwest	Cleveland	TN	37311	US	\N	\N	\N	krogers	\N	0101000020E610000014B4C9E1933955C03DD68C0C72914140
229	Peyton's Northern Distribution Center	1111 South Adams Street	Bluffton	IN	46714	US	\N	\N	\N	krogers	\N	0101000020E610000035FCB847004D55C02087776FFB5C4440
230	Smith's Layton Distribution Center	500 Sugar Street	Layton	UT	84041	US	\N	\N	\N	krogers	\N	0101000020E610000065C8B1F50CFF5BC01898158A74884440
231	Kroger Distribution Center	5305 West Buckeye Road	Phoenix	AZ	85043	US	\N	\N	\N	krogers	\N	0101000020E6100000E0BBCD1B270B5CC0637B2DE8BDB74040
232	Kroger Distribution Center	500 South 99th Avenue	Tolleson	AZ	85353	US	\N	\N	\N	krogers	\N	0101000020E6100000A3CB9BC3B5115CC09835B1C057B84040
233	Kroger Distribution Center	7770 East McDowell Road	Scottsdale	AZ	85257	US	\N	\N	\N	krogers	\N	0101000020E6100000E82109B169FA5BC0F20A444FCABB4040
324	Amazon Distribution Center #BNA2	 Duke Drive	Mount Juliet	TN	37122	US	\N	\N	\N	amazon	\N	0101000020E61000007A731310EE9955C0AF48A70936104240
325	Amazon Distribution Center #SAT1	6000 Enterprise Avenue	Schertz	TX	78154	US	\N	\N	\N	amazon	\N	0101000020E6100000AFC44D57C19258C009BA07324C993D40
326	Amazon Distribution Center #DFW6	940 West Bethel Road	Coppell	TX	75019	US	\N	\N	\N	amazon	\N	0101000020E61000004CFC51D4194158C0382D78D1577A4040
327	Amazon Distribution Center #DFW7	700 Westport Parkway	Fort Worth	TX	76177	US	\N	\N	\N	amazon	\N	0101000020E61000005D8B16A06D5558C02B685A62657C4040
328	Amazon Distribution Center #XUSB	14900 Frye Road	Fort Worth	TX	76155	US	\N	\N	\N	amazon	\N	0101000020E610000026C79DD2C14258C0D95DA0A4C0684040
329	Amazon Distribution Center #DFW1	3200 East Airfield Drive	DFW Airport	TX	75261	US	\N	\N	\N	amazon	\N	0101000020E61000002009FB76924258C00E1C8645FB724040
330	Amazon Distribution Center #RIC1	9827 Petersburg Street	Chester	VA	23831	US	\N	\N	\N	amazon	\N	0101000020E6100000CDC01259355C53C049FCE5EECEAD4240
331	Amazon Distribution Center #RIC2	1901 Meadowville Technology Parkway	Chester	VA	23836	US	\N	\N	\N	amazon	\N	0101000020E6100000100B1060EC5453C0B0E83125EDAC4240
332	Amazon Distribution Center #BFI1	1800 140th Avenue East	Sumner	WA	98390	US	\N	\N	\N	amazon	\N	0101000020E6100000A27C410B898F5EC07F9F1628CE9E4740
333	Amazon Distribution Center #SEA6 & #SEA8	1227 124th Avenue Northeast	Bellevue	WA	98005	US	\N	\N	\N	amazon	\N	0101000020E6100000B3D716F9508B5EC04CBBE2F3D4CF4740
334	Amazon Distribution Center #BFI3	2700 Center Drive	DuPont	WA	98327	US	\N	\N	\N	amazon	\N	0101000020E6100000B5ECFFD258A95EC02EB022FEBC8B4740
335	Amazon Distribution Center #SEA6	2646 Rainier Avenue South	Seattle	WA	98144	US	\N	\N	\N	amazon	\N	0101000020E6100000286D6061F7925EC02EFDF09826CA4740
234	Costco Distribution Center	8400 West Sherman Street	Tolleson	AZ	85353	US	\N	\N	\N	costco	\N	0101000020E61000003DD7529B930F5CC01E17D522A2B84040
235	Costco Distribution Center	11600 Riverside Drive	\N	CA	91752	US	\N	\N	\N	costco	\N	0101000020E61000008D90CBC955625DC0A1B0D52F22024140
236	Costco Distribution Center	 	Tracy	CA	\N	US	\N	\N	\N	costco	\N	0101000020E6100000148145D9365B5EC0D1F8CFE4ACDE4240
237	Costco Distribution Center	5851 45th Street	West Palm Beach	FL	33407	US	\N	\N	\N	costco	\N	0101000020E6100000FAE29C22510854C0585AA1A3B0C23A40
238	Costco Distribution Center	4250 South Fulton Parkway	Atlanta	GA	30349	US	\N	\N	\N	costco	\N	0101000020E61000000DF49A68212255C05E91A9CCDECE4040
239	Costco Distribution Center	3800 North Division Street	Morris	IL	60450	US	\N	\N	\N	costco	\N	0101000020E61000004AE5924F341B56C009D68228A9B24440
240	Costco Distribution Center	5236 Intercoastal Drive	Monrovia	MD	21770	US	\N	\N	\N	costco	\N	0101000020E61000007B29E1AE035253C0F6E4AB2EF1AF4340
241	Costco Distribution Center	 Costco Drive	Monroe Township	NJ	08831	US	\N	\N	\N	costco	\N	0101000020E61000008683CEB5799D52C02284EC61D42D4440
242	Costco Distribution Center	 Florina Parkway	Dallas	TX	75249	US	\N	\N	\N	costco	\N	0101000020E6100000F3AE7AC03C3D58C0AAB5D5517A524040
243	Costco Distribution Center	8510 El Gato Road	Laredo	TX	78045	US	\N	\N	\N	costco	\N	0101000020E6100000AB67F79A54E058C071CADC7C239E3B40
244	Costco Distribution Center	5995 West 300 South	Salt Lake City	UT	84104	US	\N	\N	\N	costco	\N	0101000020E610000034524A630F025CC01B6FE12F1C614440
245	Costco Distribution Center	4000 142nd Avenue East	Sumner	WA	98390	US	\N	\N	\N	costco	\N	0101000020E6100000393D940D908F5EC0667B3E14169C4740
271	Amazon Distribution Center #PHX5	16920 West Commerce Drive	Goodyear	AZ	85338	US	\N	\N	\N	amazon	\N	0101000020E6100000A19E3E02FF1A5CC00FD07D39B3B44040
272	Amazon Distribution Center #PHX6	4750 West Mohave Street	Phoenix	AZ	85043	US	\N	\N	\N	amazon	\N	0101000020E6100000A1BB24CE8A0A5CC01D716D4D5FB74040
273	Amazon Distribution Center #PHX3	6835 West Buckeye Road	Phoenix	AZ	85043	US	\N	\N	\N	amazon	\N	0101000020E6100000F530B43A390D5CC04E0D349F73B74040
274	Amazon Distribution Center #PHX7	800 North 75th Avenue	Phoenix	AZ	85043	US	\N	\N	\N	amazon	\N	0101000020E6100000B800D990240E5CC076DC950277BA4040
275	Amazon Distribution Center #ONT2	1910 East Central Avenue	San Bernardino	CA	92408	US	\N	\N	\N	amazon	\N	0101000020E6100000D5253ED2BB4F5DC0895869F7500B4140
276	Amazon Distribution Center #OAK3	 Park Center Drive	Patterson	CA	95363	US	\N	\N	\N	amazon	\N	0101000020E6100000DABB500A844A5EC0855BE3D81FBC4240
277	Amazon Distribution Center 	1909 Zephyr Street	Stockton	CA	95206	US	\N	\N	\N	amazon	\N	0101000020E61000001B800D8810505EC04148163081F54240
278	Amazon Distribution Center #OAK4	1555 Chrisman Road	Tracy	CA	95376	US	\N	\N	\N	amazon	\N	0101000020E6100000A25CBF057E595EC0FC5CC87E71DF4240
279	Amazon Distribution Center #PHL1	1 Centerpoint Boulevard	New Castle	DE	19720	US	\N	\N	\N	amazon	\N	0101000020E6100000FA635A9BC6E552C020CF2EDFFAD44340
280	Amazon Distribution Center #PHL3	1600 Johnson Way	New Castle	DE	19720	US	\N	\N	\N	amazon	\N	0101000020E6100000C405A051BAE552C0763579CA6AD44340
281	Amazon Distribution Center #PHL7	560 Merrimac Avenue	Middletown	DE	19709	US	\N	\N	\N	amazon	\N	0101000020E610000005A6D3BA0DEF52C0B5ADC15664B84340
282	Amazon Distribution Center #PHL8	727 North Broad Street	Middletown	DE	19709	US	\N	\N	\N	amazon	\N	0101000020E61000007460394206EE52C04A10093AB5BA4340
283	Amazon Distribution Center #IND6	1453 East 10th Street	Jeffersonville	IN	47130	US	\N	\N	\N	amazon	\N	0101000020E61000004B677110BE6E55C04B94185F0F254340
284	Amazon Distribution Center #IND1	4255 Anson Boulevard	Whitestown	IN	46075	US	\N	\N	\N	amazon	\N	0101000020E610000071CCB227819855C0A30392B06FFD4340
285	Amazon Distribution Center #XUSE	5100 South Indianapolis Road	Whitestown	IN	46075	US	\N	\N	\N	amazon	\N	0101000020E61000002B7F08BB729855C0A2A87D84ABFB4340
286	Amazon Distribution Center #IND4	710 South Girls School Road	Indianapolis	IN	46214	US	\N	\N	\N	amazon	\N	0101000020E6100000BFE25FBA7F9255C057CD7344BEE04340
287	Amazon Distribution Center #IND2	715 Airtech Parkway	Plainfield	IN	46168	US	\N	\N	\N	amazon	\N	0101000020E61000002B3BB313149655C0C053122395D94340
288	Amazon Distribution Center #IND5	800 Perry Road	Plainfield	IN	46168	US	\N	\N	\N	amazon	\N	0101000020E6100000B6D8EDB3CA9655C0BFB5132521D94340
289	Amazon Distribution Center #SDF8	900 Patrol Road	Jeffersonville	IN	47130	US	\N	\N	\N	amazon	\N	0101000020E610000006D5AB6D2F6C55C05059A89086304340
290	Amazon Distribution Center #TUL1	2654 U.S. 169	Coffeyville	KS	67337	US	\N	\N	\N	amazon	\N	0101000020E6100000A14731E568E757C0223C35F2D4814240
291	Amazon Distribution Center #SDF1	1105 South Columbia Avenue	Campbellsville	KY	42718	US	\N	\N	\N	amazon	\N	0101000020E61000003A6B01EB825655C06AE9C028F7A94240
292	Amazon Distribution Center #SDF2	4360 Robards Lane	Louisville	KY	40218	US	\N	\N	\N	amazon	\N	0101000020E61000008696D0B84B6C55C0B329B2310A194340
293	Amazon Distribution Center #CVG1	1155 Worldwide Boulevard	Hebron	KY	41048	US	\N	\N	\N	amazon	\N	0101000020E6100000210725CCB42D55C09C6C0377A08A4340
294	Amazon Distribution Center #CVG2	1600 Worldwide Boulevard	Hebron	KY	41048	US	\N	\N	\N	amazon	\N	0101000020E610000050C3B7B06E2E55C03CC093162E8B4340
295	Amazon Distribution Center #CVG3	3680 Langley Drive	Hebron	KY	41048	US	\N	\N	\N	amazon	\N	0101000020E61000001CA2C0F1EB2D55C0D563B6BF0E884340
296	Amazon Distribution Center #CVG5	2285 Litton Lane	Hebron	KY	41048	US	\N	\N	\N	amazon	\N	0101000020E6100000C2590009F92D55C0129FE0078C894340
336	Amazon Distribution Center #YVR2	450 Derwent Place	Delta	BC	V3M 5Y9	CA	\N	\N	\N	amazon	\N	0101000020E61000005C284F0FC0BC5EC0F2D5E99B8F944840
337	Amazon Distribution Center #YYZ1	6363 Millcreek Drive	Mississauga	ON	L5N 1L8	CA	\N	\N	\N	amazon	\N	0101000020E6100000BECF02FE3AEF53C0353113FBBACB4540
338	Amazon Distribution Center #PRTO	6110 Cantay Road	Mississauga	ON	L5R 4J8	CA	\N	\N	\N	amazon	\N	0101000020E6100000144031B2E4EB53C06540ACEDDCCF4540
246	Walgreen's Distribution Center	 	Madrid	Community of Madrid	28039	ES	Notes 1; Notes 2	\N	\N	walgreens	\N	0101000020E6100000277E3100F9A70DC037A5BC5642394440
247	Walgreen's Distribution Center	3850 Prologis Parkway	Easton	PA	18045	US	Regional Full Case Warehouses; 	\N	\N	walgreens	\N	0101000020E6100000C0A849954DD252C055206926CE5C4440
248	Walgreen's Distribution Center	5100 Lake Street	Omaha	NE	68104	US	Walgreens Distribution Center; 	\N	\N	walgreens	\N	0101000020E6100000C1E03F8287FF57C02DB4739A05A44440
249	Walgreen's Distribution Center	101 Alliance Parkway	Williamston	SC	29697	US	Walgreens Distribution Center; Anderson Distribution Center	\N	\N	walgreens	\N	0101000020E61000000DC0AB8A15A554C049D2DAD9FC504140
250	Walgreen's Distribution Center	1130 Commerce	Stuttgart	AR	72160	US	Walgreens E-Commerce Distribution Centers; East Coast DC	\N	\N	walgreens	\N	0101000020E6100000996F33CBD4DD56C0DBEF9AA1024A4140
251	Walgreen's Distribution Center	125 North Commerce Way	Bethlehem	PA	18017	US	Walgreens Distribution Center; 	\N	\N	walgreens	\N	0101000020E61000004E756D147ED852C09816F549EE564440
252	Walgreen's Distribution Center	13201 Wilfred Lane North	Rogers	MN	55374	US	Regional Full Case Warehouses; 	\N	\N	walgreens	\N	0101000020E6100000249BABE6396257C07026A60BB1984640
253	Walgreen's Distribution Center	15998 Walgreens Drive	Jupiter	FL	33478	US	Walgreens Distribution Center; 	\N	\N	walgreens	\N	0101000020E61000006A15FDA1991054C0ACE3F8A1D2E83A40
254	Walgreen's Distribution Center	17500 North Perris Boulevard	Moreno Valley	CA	92551	US	Walgreens Distribution Center; 	\N	\N	walgreens	\N	0101000020E610000058ACE122774E5DC01D7D827AE9EE4040
255	Walgreen's Distribution Center	1805 Greens Road	Houston	TX	77032	US	Regional Full Case Warehouses; 	\N	\N	walgreens	\N	0101000020E61000004DA83BAA75D757C03BA17CE651F43D40
256	Walgreen's Distribution Center	2020 6th Street	Alva	OK	73717	US	Walgreens Distribution Center; c/o Laney & Duke, Puerto Rico Consolidation DC	\N	\N	walgreens	\N	0101000020E61000004985B185A0AA58C04910AE8042644240
257	Walgreen's Distribution Center	2370 East Main Street	Mohegan Lake	NY	10547	US	Walgreens Distribution Center; 	\N	\N	walgreens	\N	0101000020E610000066AEC21CF37652C07FFB3A70CEA84440
258	Walgreen's Distribution Center	2400 North Walgreen Boulevard	Flagstaff	AZ	86004	US	Walgreens Distribution Center; 	\N	\N	walgreens	\N	0101000020E610000045662E7079E65BC04F667220DA9A4140
259	Walgreen's Distribution Center	2455 Premier Row	Orlando	FL	32809	US	Walgreens Distribution Center; 	\N	\N	walgreens	\N	0101000020E6100000E245BAFA8C5A54C023CCFE8A46763C40
260	Walgreen's Distribution Center	2777 USA Parkway	Sparks	NV	89434	US	Walgreens E-Commerce Distribution Centers; GSI Commerce	\N	\N	walgreens	\N	0101000020E61000006FBA658778DE5DC059EE1692DDC24340
261	Walgreen's Distribution Center	28 Gateway Commerce Center Drive East	Roxana	IL	62084	US	Walgreens E-Commerce Distribution Centers; Walgreens Internet Fulfillment Centers	\N	\N	walgreens	\N	0101000020E61000007246DE83A18356C0063E50B868634340
262	Walgreen's Distribution Center	28727 Oregon Road	Perrysburg	OH	43551	US	Walgreens Distribution Center; 	\N	\N	walgreens	\N	0101000020E61000004B1FBAA0BEE254C0E867EA758BC84440
263	Walgreen's Distribution Center	350 Raco Parkway	Pendergrass	GA	30567	US	Regional Full Case Warehouses; 	\N	\N	walgreens	\N	0101000020E6100000C3F5285C8FE654C01A18795913194140
265	Walgreen's Distribution Center	4400 State Road	Ridgeville	SC	29472	US	Walgreens Distribution Center; 	\N	\N	walgreens	\N	0101000020E61000001C8645FB0E1254C0E61CE159279C4040
108	Walmart Distribution Center	 	Parsons	WV	26287	US	\N	\N	\N	walmart	\N	0101000020E6100000FBF664B4C4E853C050447529649B4340
264	Walgreen's Distribution Center	370 West Crossroads Parkway	Bolingbrook	IL	60440	US	Walgreens Distribution Center; "New Store Openings"	\N	\N	walgreens	\N	0101000020E61000002907B309300556C0E0490B9755D64440
266	Walgreen's Distribution Center	50-02 55th Avenue	Queens	NY	11378	US	Walgreens Distribution Center; DuaneReade Distribution Center	\N	\N	walgreens	\N	0101000020E61000002127A7D1BF7A52C08A7DB89A2B5D4440
267	Walgreen's Distribution Center	5300 Saint Charles Road	Berkeley	IL	60163	US	Walgreens Distribution Center; 	\N	\N	walgreens	\N	0101000020E6100000A3DF6355A9F955C042284A9DDBF14440
268	Walgreen's Distribution Center	710 Ovilla Road	Waxahachie	TX	75167	US	Walgreens Distribution Center; 	\N	\N	walgreens	\N	0101000020E610000078C1960DA13758C063D34A2190374040
269	Walgreen's Distribution Center	730 Florida 30	Pensacola	FL	32502	US	Walgreens Distribution Center; Walgreens Return Center	\N	\N	walgreens	\N	0101000020E610000005076AE76ACE55C078352F3D50693E40
270	Walgreen's Distribution Center	80 International Parkway	Sunrise	FL	33325	US	Walgreens Distribution Center; 	\N	\N	walgreens	\N	0101000020E6100000E8FE452BD21554C0BA96DA9C94213A40
297	Amazon Distribution Center #LEX1	1850 Mercer Road	Lexington	KY	40511	US	\N	\N	\N	amazon	\N	0101000020E6100000342A15F91A2255C0DE1D19ABCD094340
298	Amazon Distribution Center #LEX2	172 Trade Street	Lexington	KY	40511	US	\N	\N	\N	amazon	\N	0101000020E6100000E692AAED262355C0ABB35A608F094340
299	Amazon Distribution Center #SDF4	 	Shepherdsville	KY	40165	US	\N	\N	\N	amazon	\N	0101000020E6100000EF81678C206D55C06BFA473A5EFB4240
300	Amazon Distribution Center #SDF6	 Omega Parkway	Shepherdsville	KY	40165	US	\N	\N	\N	amazon	\N	0101000020E6100000745E6397A86B55C072E0D57267FC4240
301	Amazon Distribution Center #SDF7	 Omicron Court	Shepherdsville	KY	40165	US	\N	\N	\N	amazon	\N	0101000020E61000001BF4A5B73F6B55C00727A25F5BFB4240
302	Amazon Distribution Center #SDF9	 	Shepherdsville	KY	40165	US	\N	\N	\N	amazon	\N	0101000020E61000006C2EED8ACF6D55C0ABF298DC83FE4240
303	Amazon Distribution Center #RNO1	1600 East Newlands Road	Fernley	NV	89408	US	\N	\N	\N	amazon	\N	0101000020E6100000B7989F1B9ACD5DC043AED4B320CE4340
304	Amazon Distribution Center #LAS2	3837 Bay Lake Trail	North Las Vegas	NV	89030	US	\N	\N	\N	amazon	\N	0101000020E61000003411363CBDC65CC03CFA5FAE451D4240
305	Amazon Distribution Center #BOS1	10 State Street	Nashua	NH	03063	US	\N	\N	\N	amazon	\N	0101000020E6100000F7CDFDD5E3E151C082ACA7565F654540
306	Amazon Distribution Center #EWR5	301 Blair Road	Avenel	NJ	07001	US	\N	\N	\N	amazon	\N	0101000020E6100000D73F3ED72D9052C00F513BB2A84B4440
307	Amazon Distribution Center #AVP1	550 Oakridge Road	Hazleton	PA	18202	US	\N	\N	\N	amazon	\N	0101000020E61000002375F16D300353C0ED5A8CCB02764440
308	Amazon Distribution Center #ABE2	705 Boulder Drive	Breinigsville	PA	18031	US	\N	\N	\N	amazon	\N	0101000020E61000005F251FBB8BE752C00B1467FB46474440
309	Amazon Distribution Center #ABE3	650 Boulder Drive	Breinigsville	PA	18031	US	\N	\N	\N	amazon	\N	0101000020E61000008D45D3D9C9E752C0F10F5B7A34474440
310	Amazon Distribution Center #ABE5	6455 Allentown Boulevard	Harrisburg	PA	17112	US	\N	\N	\N	amazon	\N	0101000020E610000085EAE6E26F3153C000E48409A3294440
311	Amazon Distribution Center #PHL5	500 McCarthy Drive	Lewisberry	PA	17339	US	\N	\N	\N	amazon	\N	0101000020E6100000611A868F883553C042D2A755F4154440
312	Amazon Distribution Center #PHL6	675 Allen Road	Carlisle	PA	17015	US	\N	\N	\N	amazon	\N	0101000020E610000053A236BBFF4E53C0AEFAB72638164440
313	Amazon Distribution Center #PHL4	21 Roadway Drive	Carlisle	PA	17015	US	\N	\N	\N	amazon	\N	0101000020E6100000728C648F504753C0D7A3703D0A1D4440
314	Amazon Distribution Center #VUBA	1000 Keystone Industrial Park Road	Scranton	PA	18512	US	\N	\N	\N	amazon	\N	0101000020E6100000E0DA899290E652C012ED743117B84440
315	Amazon Distribution Center #VUGA	508 Delaware Avenue	\N	PA	18643	US	\N	\N	\N	amazon	\N	0101000020E61000009111AB9A7BF352C0BF7C57A945AA4440
316	Amazon Distribution Center #XUSC	40 Logistics Drive	Carlisle	PA	17013	US	\N	\N	\N	amazon	\N	0101000020E610000019FD0D7F724E53C0944A1D893C184440
317	Amazon Distribution Center #GSP1	402 John Dodd Road	Spartanburg	SC	29303	US	\N	\N	\N	amazon	\N	0101000020E61000000BF7802F3B8254C007955DD5FE804140
318	Amazon Distribution Center 	4400 12th Street Extension	West Columbia	SC	29172	US	\N	\N	\N	amazon	\N	0101000020E61000007C0A80F10C4354C013E85D06ADF44040
319	Amazon Distribution Center #CAE1	4400 12th Street Extension	West Columbia	SC	29172	US	\N	\N	\N	amazon	\N	0101000020E61000007C0A80F10C4354C013E85D06ADF44040
320	Amazon Distribution Center #CHA1	7200 Discovery Drive	Chattanooga	TN	37421	US	\N	\N	\N	amazon	\N	0101000020E61000000CCE3BA90A4955C06AE27899BC884140
321	Amazon Distribution Center #BNA3	2020 Joe B Jackson Parkway	Murfreesboro	TN	37127	US	\N	\N	\N	amazon	\N	0101000020E610000031EE06D15A9755C01A7AD51412E44140
322	Amazon Distribution Center #BNA1	14840 Central Pike	Lebanon	TN	37090	US	\N	\N	\N	amazon	\N	0101000020E610000079B29B19FD9955C0E4D70FB1C1104240
323	Amazon Distribution Center #CHA2	 	Charleston	TN	\N	US	\N	\N	\N	amazon	\N	0101000020E61000006DF9ED90873055C01E26D016C6A44140
1	Walmart Distribution Center	2200 7th Avenue Southwest	Cullman	AL	35055	US	Originally constructed to 900,000 sq ft and expanded to 1.2M sq ft in 1988. 11 miles of conveyors.	\N	1200000	walmart	1983-01-01	0101000020E6100000F41B81D316B655C057D0B4C4CA114140
2	Walmart Distribution Center	5841 Southwest Regional Airport Boulevard	Bentonville	AR	72712	US	12 miles of conveyors.	\N	1200000	walmart	\N	0101000020E6100000DF65D01ACD9057C0538C987E2E294240
3	Walmart Distribution Center	405 East Booth Road	Searcy	AR	72143	US	\N	\N	1100000	walmart	1990-05-01	0101000020E6100000B8B30AF6BAEE56C0719F6692A29C4140
4	Walmart Distribution Center	23701 West Southern Avenue	Buckeye	AZ	85326	US	Originally constructed to 1.2 M sq ft, this facility was expanded by 352,000 sq ft in 1999 to add a Sam's cross dock facility on the same site. This is a free trade zone (FTZ) facility that can process import merchandise.	\N	1550000	walmart	1993-03-01	0101000020E6100000B64C86E3F9235CC01FF7ADD689B14040
5	Walmart Distribution Center	21101 Johnson Road	Apple Valley	CA	92307	US	\N	\N	1340000	walmart	2004-03-01	0101000020E61000002843554CA54C5DC01D3BA8C4754C4140
6	Walmart Distribution Center	1300 South F Street	Porterville	CA	93257	US	\N	\N	1200000	walmart	1991-09-01	0101000020E61000007F33315D88C15DC014B01D8CD8054240
7	Walmart Distribution Center	 	Red Bluff	CA	96080	US	11 Miles of conveyor.	\N	1170000	walmart	1994-01-01	0101000020E61000002F1A8DD7178F5EC0BBDAE5B6D8164440
8	Walmart Distribution Center	7500 East Crossroads Boulevard	Loveland	CO	80538	US	\N	\N	1078500	walmart	1990-09-01	0101000020E6100000562DE928073E5AC0CEC4742156374440
9	Walmart Distribution Center	4860 Wheatleys Pond Road	Smyrna	DE	19977	US	General Merchandise RDC.	\N	1200000	walmart	2004-01-01	0101000020E61000004AB72572C1E752C06AF5D55581A44340
142	Walmart Distribution Center	10695 Freedom Trail	Gordonsville	VA	22942	US	Facility expanded in 2009.	\N	880000	walmart	2003-04-01	0101000020E6100000293FA9F6E98C53C07DE65196C6FD4240
10	Walmart Distribution Center	18815 Northwest 115th Terrace	Alachua	FL	32615	US	General Merchandise RDC built for $55M.	\N	1200000	walmart	2006-09-01	0101000020E61000001F227F7AFD9D54C0F62E39494EE73D40
11	Walmart Distribution Center	5100 Kettering Road	Brooksville	FL	34602	US	Originally built to 1.1 Million sq ft and later expanded in 1996 and 1999.	\N	1600000	walmart	1992-01-01	0101000020E6100000F37519FED38D54C02B6D718DCF803C40
12	Walmart Distribution Center	4001 South Jenkins Road	Fort Pierce	FL	34981	US	\N	\N	1200000	walmart	2004-08-01	0101000020E6100000B804E09FD21854C011A4F732F6643B40
13	Walmart Distribution Center	690 Highway 206	Douglas	GA	31533	US	Walmart's 8th distribution center was originally built to 700,000 sq ft.	\N	994000	walmart	1986-01-01	0101000020E610000011B5238BEAB754C0F41373B5BA7F3F40
14	Walmart Distribution Center	385 Callaway Church Road	LaGrange	GA	30241	US	General Merchandise RDC built for $55 Million.	\N	1130000	walmart	2000-03-01	0101000020E610000094313ECC5E3D55C02DB308C556844040
15	Walmart Distribution Center	1100 North Iris Street	Mount Pleasant	IA	52641	US	Walmart's 8th distribution center was originally built to 650,000 sq ft and was later expanded in 1987.	\N	1244000	walmart	1985-01-01	0101000020E6100000643090B1A4E156C0E9BC21E8C37C4440
16	Walmart Distribution Center	3100 Highway 89	Spring Valley	IL	61362	US	\N	\N	1200000	walmart	2001-03-01	0101000020E6100000DE49FA6AFD4D56C03DCF447D37AD4440
17	Walmart Distribution Center	2100 East Tipton Street	Seymour	IN	47274	US	\N	\N	1100000	walmart	1990-03-01	0101000020E6100000CC28965B5A7655C0C4B5DAC35E7A4340
18	Walmart Distribution Center	 	Ottawa	KS	66067	US	\N	\N	1200000	walmart	1995-09-01	0101000020E61000008DE0905731D157C030F65E7CD14E4340
19	Walmart Distribution Center	690 Crenshaw Boulevard	Hopkinsville	KY	42240	US	15 Miles of conveyor.	\N	1200000	walmart	2002-01-01	0101000020E61000003D4A80F593DE55C0D7FA22A12D5E4240
20	Walmart Distribution Center	3160 Highway 743	Opelousas	LA	70570	US	\N	\N	1200000	walmart	1999-09-01	0101000020E6100000EACC3D24FC0157C0395E81E849953E40
21	Walmart Distribution Center	510 Jonesville Road	Coldwater	MI	49036	US	\N	\N	1100000	walmart	2001-06-01	0101000020E6100000CC6E77207C3E55C0CE50DCF126FE4440
22	Walmart Distribution Center	 Matlock Drive	St. James	MO	65559	US	\N	\N	1200000	walmart	2001-09-01	0101000020E610000095A6F74322E856C0D9356B3A4C014340
23	Walmart Distribution Center	2210 Manufacturers Boulevard Northeast	Brookhaven	MS	39601	US	Walmart's 9th distribution center was originally built to 700,000 sq ft.	\N	1000000	walmart	1986-08-01	0101000020E61000004CA02D8C199B56C0078BD4C5B7993F40
24	Walmart Distribution Center	1057 Sand Hill Road	Hope Mills	NC	28348	US	\N	\N	1200000	walmart	1997-09-01	0101000020E6100000E71C3C139AB953C04E97C5C4E6774140
25	Walmart Distribution Center	220 Walmart Drive	Shelby	NC	28150	US	\N	\N	1200000	walmart	2002-09-01	0101000020E61000004D75B7A1186554C0337C5578E1A74140
26	Walmart Distribution Center	42 Freetown Road	Raymond	NH	03077	US	\N	\N	1100000	walmart	1996-09-01	0101000020E61000008E507D3125CA51C08FA850DD5C834540
27	Walmart Distribution Center	8827 Old River Road	Marcy	NY	13403	US	\N	\N	1200000	walmart	1994-03-01	0101000020E610000010E6762FF7D352C04D86E3F90C964540
28	Walmart Distribution Center	3880 Southwest Boulevard	Grove City	OH	43123	US	\N	\N	1100000	walmart	1992-03-01	0101000020E610000050429F7E86C654C08BDD3EABCCF24340
29	Walmart Distribution Center	2650 South Highway 395	Hermiston	OR	97838	US	\N	\N	1175000	walmart	1997-01-01	0101000020E61000008F3287495DD05DC0757E4056A6E74640
30	Walmart Distribution Center	300 Veterans Drive	Pocono Summit	PA	18346	US	\N	\N	1119245	walmart	2002-02-01	0101000020E61000008D74AB8CEBD952C0A62A6D718D944440
31	Walmart Distribution Center	 	Woodland	PA	16881	US	\N	\N	1190000	walmart	1993-09-01	0101000020E610000096FD0461389453C0ADAD8ED25B834440
32	Walmart Distribution Center	 	Midway	TN	37809	US	\N	\N	1200000	walmart	1997-04-01	0101000020E61000004A737511F0C054C055F3C1D77C154240
33	Walmart Distribution Center	 North Ih 35	New Braunfels	TX	78130	US	Originally built to 984,000 sq ft in 1988 and later expanded in 1998. Also services as an electronics repairs DC.	\N	1204000	walmart	1988-08-01	0101000020E6100000B537F8C2E48558C05F2BFC7497B33D40
34	Walmart Distribution Center	 	Palestine	TX	\N	US	\N	\N	1200000	walmart	1996-01-01	0101000020E610000017CB3ED95EE857C0FF4701FD19C33F40
35	Walmart Distribution Center	3100 Interstate 27	Plainview	TX	79072	US	Originally built to 700,000 sq ft and later expanded in 1998.	\N	1200000	walmart	1986-09-01	0101000020E6100000FA4FEDC2C56E59C04C885EEBF71A4140
36	Walmart Distribution Center	2120 North Stemmons Street	Sanger	TX	76266	US	\N	\N	1200000	walmart	2001-08-01	0101000020E61000003C7A0D0BFF4A58C0B022FEBC04B34040
37	Walmart Distribution Center	 Brast Road	Sealy	TX	77474	US	\N	\N	1200000	walmart	2005-01-01	0101000020E610000054837A44960B58C095151E8F74BD3D40
38	Walmart Distribution Center	929 Route 138	Grantsville	UT	84029	US	\N	\N	1250000	walmart	2005-07-01	0101000020E6100000774A07EBFF1A5CC09E5F94A0BF4C4440
39	Walmart Distribution Center	 	Mount Crawford	VA	22841	US	\N	\N	1200000	walmart	2005-01-01	0101000020E61000003124271337BC53C08CEB2983B42D4340
40	Walmart Distribution Center	21504 Cox Road	Petersburg	VA	23803	US	\N	\N	1200000	walmart	1991-12-01	0101000020E610000057CEDE196D6253C0573ECBF3E0984240
41	Walmart Distribution Center	115 Distribution Way	Beaver Dam	WI	53916	US	\N	\N	1200000	walmart	2007-03-01	0101000020E610000034CA445BDF3256C042226DE34FC14540
42	Walmart Distribution Center	6100 3M Drive	Menomonie	WI	54751	US	\N	\N	1170000	walmart	1993-04-01	0101000020E61000000156A247E7F656C046E7A15B54734640
43	Walmart Distribution Center	 Childs Avenue	Merced	CA	95341	US	Walmart first sought approval for this facility in 2002 and public resistance delayed the controversial approval which was finally received in Nov 2012.	\N	1200000	walmart	\N	0101000020E61000007E88B25C5B1D5EC0144EC1D0D9A44240
44	Walmart Distribution Center	3301 East Park Avenue	Searcy	AR	72143	US	Owned and Operated. Originally constructed as a 390,000 sq ft. Walmart's first DC outside of Bentonville and 4th DC. Expanded by 142,000 sq ft in 1981 and again in 1990 and then converted into a Sams Collectables DC in 1994.	\N	682700	walmart	1978-07-01	0101000020E61000004A7F2F8587EC56C075070CEDF79E4140
45	Walmart Distribution Center	23701 West Southern Avenue	Buckeye	AZ	85326	US	Owned and Operated. This facility is on the same site as DC#6031.	\N	252000	walmart	2000-01-01	0101000020E6100000B64C86E3F9235CC01FF7ADD689B14040
46	Walmart Distribution Center	1600 Tide Court	Woodland	CA	95776	US	Sam's Crossdock facility run by 3PL Exel Logistics.	\N	65200	walmart	2004-08-01	0101000020E61000004CF7DFEFBC6F5EC088E64BB90C574340
47	Walmart Distribution Center	1000 South Cucamonga Avenue	Ontario	CA	91761	US	Sam's Crossdock facility run by 3PL Vitran Logistics Inc.	\N	60000	walmart	\N	0101000020E6100000A23726D588685DC068B922E7B3064140
48	Walmart Distribution Center	7500 East Crossroads Boulevard	Loveland	CO	80538	US	Owned and Operated.	\N	42600	walmart	1990-09-01	0101000020E6100000562DE928073E5AC0CEC4742156374440
49	Walmart Distribution Center	 	Jacksonville	FL	32226	US	\N	\N	129665	walmart	2013-02-01	0101000020E61000006A1261689A5F54C067C92DF713753E40
50	Walmart Distribution Center	3010 Saddle Creek Road	Lakeland	FL	33801	US	Sam's Crossdock facility run by 3PL SaddleCreek Logistics.	\N	66400	walmart	1991-01-01	0101000020E610000057975302627954C05DA79196CA133C40
51	Walmart Distribution Center	140 Fleet Drive	Villa Rica	GA	30180	US	Sam's Crossdock facility run by 3PL SaddleCreek Logistics.	\N	60000	walmart	1995-01-01	0101000020E6100000A164726A673C55C0707B82C476DF4040
52	Walmart Distribution Center	 Central Avenue	University Park	IL	60484	US	Sam's Crossdock facility run by 3PL Vitran Logistics.	\N	49200	walmart	2005-06-01	0101000020E6100000A00A6E5ADFEF55C0F480C355AFB94440
53	Walmart Distribution Center	488 West Muskegon Drive	Greenfield	IN	46140	US	Owned and Operated.	\N	85200	walmart	\N	0101000020E61000005BD1E638B77155C08EB0A888D3E74340
54	Walmart Distribution Center	14557 Industry Drive	Hagerstown	MD	21742	US	Sam's Crossdock facility run by Kane is Able.	\N	40000	walmart	1994-01-01	0101000020E610000018963FDF166E53C0B724AC32F8DB4340
55	Walmart Distribution Center	18650 Dix Toledo Highway	Brownstown Charter Township	MI	48193	US	Sam's Crossdock facility run by ASW Global, LLC.	\N	60000	walmart	1992-01-01	0101000020E61000004A58C0A934CF54C04C981F6E3D164540
56	Walmart Distribution Center	6301 West Old Shakopee Road	Bloomington	MN	55438	US	Owned and Operated.	\N	180300	walmart	1995-02-01	0101000020E61000003B3602F13A5757C07E46D8A667674640
57	Walmart Distribution Center	233 South 42nd Street	Kansas City	KS	66106	US	Sam's Crossdock facility formerly run by Wagner Industries up to May 2012.	\N	81080	walmart	1988-01-01	0101000020E610000052B7B3AF3CAB57C0562AA8A8FA8B4340
58	Walmart Distribution Center	185 J M Tatum Industrial Drive	Hattiesburg	MS	39401	US	Sam's Crossdock facility run by 3PL SaddleCreek Logistics.	\N	60000	walmart	2008-05-01	0101000020E610000043684EA8F15056C0C6B4801A08453F40
59	Walmart Distribution Center	1911 Continental Boulevard	Charlotte	NC	28273	US	Sam's Crossdock facility run by 3PL Distribution Technology Inc.	\N	63400	walmart	1991-01-01	0101000020E61000007714E7A8A33B54C019703BD972904140
60	Walmart Distribution Center	 	Hooksett	NH	03106	US	Sam's Crossdock facility formerly run by PSI - Puget Sound International which went out of business in Sep, 2012.	\N	26200	walmart	2005-01-01	0101000020E610000007CF842609DD51C059B1AEC0468A4540
61	Walmart Distribution Center	2150 International Parkway	North Canton	OH	44720	US	Sam's Crossdock facility run by ASW Global, LLC.	\N	75000	walmart	\N	0101000020E6100000B5EA29287B5D54C0D8A9A8B008754440
62	Walmart Distribution Center	26 Stauffer Industrial Park	Taylor	PA	18517	US	Sam's Crossdock facility run by Kane is Able.	\N	70000	walmart	1990-01-01	0101000020E6100000F159E89411ED52C016CE7F59EBB24440
63	Walmart Distribution Center	 North Ih 35	New Braunfels	TX	78130	US	Owned and Operated. Located on the same site as Walmart DC#6016.	\N	60000	walmart	1998-01-01	0101000020E6100000B537F8C2E48558C05F2BFC7497B33D40
64	Walmart Distribution Center	830 East Centre Park Boulevard	DeSoto	TX	75115	US	Owned and Operated.	\N	92800	walmart	\N	0101000020E61000003F598C15903558C0A64D8BB0974F4040
65	Walmart Distribution Center	451 Farm to Market 686	Dayton	TX	77535	US	Owned and Operated.	\N	100000	walmart	1995-04-01	0101000020E6100000C24769DB55BB57C06A1FE16A53193E40
66	Walmart Distribution Center	2810 North Marshall Street	Tacoma	WA	98421	US	Sam's Crossdock facility formerly run by PSI - Puget Sound International which went out of business in Sep, 2012. Vitran Logistics is now the 3PL operator.	\N	103200	walmart	\N	0101000020E6100000B5C35F9335995EC0054EB6813BA04740
67	Walmart Distribution Center	 Black Diamond Circle	Laredo	TX	78045	US	Export distribution center to distribute export merchandise for Walmart Mexico.	\N	191700	walmart	1992-01-01	0101000020E6100000B0FB33283FEE58C038B1D183CCB73B40
68	Walmart Distribution Center	801 Corda Boulevard	Crawfordsville	IN	47933	US	Optical Lab / Plant.	\N	31400	walmart	1993-01-01	0101000020E61000009FA39FBA83B755C0F499FDCBFF054440
69	Walmart Distribution Center	2314 West 6th Street	Fayetteville	AR	72701	US	Optical Lab / Plant.	\N	64500	walmart	1987-03-01	0101000020E61000000E82339D428C57C0ADED3724FF064240
70	Walmart Distribution Center	9029 Directors Row	Dallas	TX	75247	US	Optical Lab / Plant.	\N	38918	walmart	2003-06-01	0101000020E6100000E16D94AB0E3958C097265B13C1684040
71	Walmart Distribution Center	2252 North 8th Street	Rogers	AR	72756	US	Started as a Redistribution DC in 1976 and converted into a VAWD accredited Pharmacy Distribution Center.	\N	150000	walmart	1976-11-01	0101000020E6100000D6C9198A3B8857C0357EE195242D4240
72	Walmart Distribution Center	1201 Moberly Lane	Bentonville	AR	72712	US	Pharmacy Distribution Center. Pharmacy Returns DC.	\N	40000	walmart	2001-01-01	0101000020E6100000BABC395CAB8B57C02ECBD765F82D4240
73	Walmart Distribution Center	13231 11th Avenue	Hanford	CA	93230	US	Pharmacy Distribution Center.	\N	70900	walmart	1994-03-01	0101000020E610000053CC41D0D1E95DC035F0A31AF6234240
74	Walmart Distribution Center	 Walmart Way	Tifton	GA	31794	US	Pharmacy Distribution Center.	\N	86500	walmart	1988-01-01	0101000020E61000003FEDA64ACADE54C0D47FD6FCF86B3F40
75	Walmart Distribution Center	11121 Elliott Place	Williamsport	MD	21795	US	Converted a Photo lab into a Pharmaceutical Distribution Center.	\N	66300	walmart	1997-01-01	0101000020E61000006EFB1EF5D77353C00FBA84436FCF4340
76	Walmart Distribution Center	1108 Southeast 10th Street	Bentonville	AR	72712	US	Print Solutions Distribution Center which is an In-house plant dedicated to printing materials such as signage, training manuals, labels, guides, forms, etc. Originally constructed to 198,000 sf and expanded in 2007.	\N	390000	walmart	1997-03-01	0101000020E61000007C43E1B3758C57C05B79C9FFE42D4240
77	Walmart Distribution Center	1102 Southeast 5th Street	Bentonville	AR	72712	US	Originally constructed to 150,000 sq ft to serve as a redistribution center. Later expanded in 1981. This was the 2nd DC in the network. Currently serves as a Walmart Return Center with 400 associates.	\N	225000	walmart	1975-01-01	0101000020E61000000CBD0F51968C57C0B87E55890D2F4240
78	Walmart Distribution Center	1901 Southeast 10th Street	Bentonville	AR	72712	US	Walmart & Sams Club Return Distribution Center.	\N	675000	walmart	\N	0101000020E61000004FEF3DB72B8C57C06A882AFC192E4240
79	Walmart Distribution Center	601 North Walton Boulevard	Bentonville	AR	72712	US	Walmart Reclamation Center.	\N	72000	walmart	2005-09-01	0101000020E6100000C2F693313E8E57C0EECD6F9868304240
80	Walmart Distribution Center	3333 North Franklin Road	Indianapolis	IN	46226	US	Outsourced to 3PL Exel Logistics. Walmart Return Distribution Center.	\N	266400	walmart	\N	0101000020E6100000227A08999A8155C0F3E7DB82A5E84340
81	Walmart Distribution Center	1900 Aerojet Way	North Las Vegas	NV	89030	US	Outsourced to 3PL Exel Logistics. Walmart Return Distribution Center.	\N	106700	walmart	\N	0101000020E610000071FF91E9D0C75CC01D3BA8C4751E4240
82	Walmart Distribution Center	161 Enterprise Road	Johnstown	NY	12095	US	Outsourced to 3PL Power Logistics of Exel North American Logistics, Inc. Walmart Return Distribution Center.	\N	207600	walmart	1996-01-01	0101000020E6100000300F99F2219952C0761893FE5E7E4540
174	Target Distribution Center	7008 Willow Lane	Minneapolis	MN	55430	US	\N	\N	\N	target	\N	0101000020E610000061AA99B5145257C0742497FF908A4640
83	Walmart Distribution Center	5795 North Blackstock Road	Spartanburg	SC	29303	US	Outsourced to 3PL Exel Logistics. Walmart Return Distribution Center that replaced a Return center in Macon GA which was closed Sep 2009.	\N	266400	walmart	2009-04-01	0101000020E6100000DB08D517538254C033DE567A6D804140
84	Walmart Distribution Center	2301 Corporation Parkway	Waco	TX	76712	US	Walmart Return Distribution Center.	\N	220000	walmart	2004-01-01	0101000020E6100000CB1DEC037F4A58C0F9FC8BFBEA7D3F40
85	Walmart Distribution Center	 	Rogers	AR	\N	US	Walmart Refurb Center. Refurb & certify smartphones, tablets and computer returns.	\N	\N	walmart	2013-04-01	0101000020E61000004218891A968757C0C5D0459E7F2A4240
86	Walmart Distribution Center	 	Tahlequah	OK	74464	US	Walmart Refurb Center run by the Cherokee Nation. Refurb & certify smartphones, tablets and computer returns.	\N	\N	walmart	2013-01-01	0101000020E6100000C6A354C213BE57C0A9DE1AD82AF54140
87	Walmart Distribution Center	 	McDonough	GA	\N	US	Outsourced to 3PL Exel Logistics. Tire Distribution Center that ships tires to over 700 Walmart and Sam's Club stores in the Southeast.	\N	357120	walmart	2001-11-01	0101000020E61000007242322E660955C0FCE82F4F42B94040
88	Walmart Distribution Center	4130 Port Boulevard	Dallas	TX	75241	US	Outsourced to 3PL Exel Logistics. Tire Distribution Center.	\N	420000	walmart	2002-04-01	0101000020E6100000BB5F05F86E3058C0CF6740BD19534040
89	Walmart Distribution Center	 	Guaynabo	Guaynabo	00968	PR	RDC to service GM and Food to Puerto Rico for all Walmart and Sam's Club stores.	\N	355000	walmart	\N	0101000020E6100000A4DBB7FFED8750C030C26F9E45663240
90	Walmart Distribution Center	3101 Highway 27 North	Carrollton	GA	30117	US	Dedicated Walmart.com distribution center.	\N	1000000	walmart	2002-01-01	0101000020E61000002A029CDEC54755C0865C0421B4D14040
91	Walmart Distribution Center	5300 Westport Parkway	Fort Worth	TX	76177	US	Dedicated Walmart.com distribution center. Outsourced to 3PL Ozburn-Hessey Logistics, LLC.	\N	788160	walmart	2013-10-01	0101000020E6100000E811A3E7165058C0724F57772C7C4040
92	Walmart Distribution Center	2785 Commerce Center Boulevard	Bethlehem	PA	18015	US	Dedicated Walmart.com distribution center.	\N	1200000	walmart	\N	0101000020E61000001E47BDF1FFD452C096ECD808C44D4440
93	Walmart Distribution Center	702 Southwest 8th Street	Bentonville	AR	72712	US	Walmart's first ever distribution center opened in 1970 as a General Merchandise & Fashion facility. Originally 60,000 sq ft; expanded to 124,800 in 1971; expanded again to 236,800 sq ft in 1972. Closed and converted into head office space in 1986.	closed	236800	walmart	1970-01-01	0101000020E6100000130A1170088E57C0FE2C9622F92E4240
94	Walmart Distribution Center	12400 Riverside Drive	Eastvale	CA	91752	US	Import Center that was vacated around or before 2009.	closed	397630	walmart	1999-08-01	0101000020E6100000D13C80457E635DC08335CEA623024140
95	Walmart Distribution Center	11850 Riverside Drive	\N	CA	91752	US	Import Center that was vacated around or before 2009.	closed	656000	walmart	2001-06-01	0101000020E61000007D1A4174D2625DC0093C8B3963024140
96	Walmart Distribution Center	2356 Fleetwood Drive	Riverside	CA	92509	US	Castle & Cook Cold Storage facility.	closed	253000	walmart	2001-01-01	0101000020E6100000D236FE4465585DC0DB8827BB99014140
97	Walmart Distribution Center	163 Portside Court	Savannah	GA	31407	US	Import Center that was closed in 2008 and consolidated into the Statesboro, GA facility.	closed	800000	walmart	2001-01-01	0101000020E61000003664F2BC8A4C54C0B0FF3A376D144040
98	Walmart Distribution Center	1080 Charleston Regional Parkway	Charleston	SC	29492	US	Import Center constructed for Walmart in a FTZ Zone in 2001-2002 and closed in 2006.	closed	560000	walmart	2002-01-01	0101000020E61000004750A15F00FA53C0D9A1500592744040
99	Walmart Distribution Center	2525 Rohr Road	Lockbourne	OH	43137	US	Optical Lab closed in Mar 2009.	closed	414000	walmart	2001-01-01	0101000020E6100000D7A02FBDFDBB54C057355200D6EB4340
100	Walmart Distribution Center	19688 Van Ness Avenue	Torrance	CA	90501	US	Import Center that was associated to the McLane's acquisition.	closed	1087500	walmart	1994-01-01	0101000020E6100000463DE9E948945DC0C537B984E8EC4040
101	Walmart Distribution Center	1110 Southeast 10th Street	Bentonville	AR	72712	US	Walmart's 11th distribution center which also serves as a returns center, a jewelry distribution center, and a jewelry repair location for Sam's.	\N	640000	walmart	1986-01-01	0101000020E6100000F024D86E718C57C05917B7D1002E4240
102	Walmart Distribution Center	2100 Southeast 5th Street	Bentonville	AR	72712	US	Originally constructed to 390,000 sq ft and later expanded in 1981.	\N	705600	walmart	1980-02-01	0101000020E61000006C0A6476168C57C0D3BD4EEACB2E4240
103	Walmart Distribution Center	333 South 10th Street	Greencastle	IN	46135	US	Originally constructed to 937,000 sq ft. Expanded twice since 1991. 15 miles of conveyor.	\N	1515000	walmart	1991-12-01	0101000020E61000004CB560F33BB555C0EEE5E37F97D14340
104	Walmart Distribution Center	 U.S. 20	\N	\N	\N	US	Distributes Apparel and shoes.	\N	800000	walmart	1995-08-01	0101000020E6100000E7621DD83BC357C0F5865682203C4540
105	Walmart Distribution Center	1050 Vern Cora Road	Laurens	SC	29360	US	Originally constructed to 583,000 sq ft;. Expanded in 1992. Facility converted into a Fashion DC in 2002.	\N	1630860	walmart	1988-01-01	0101000020E6100000CB4C69FD2D8054C0CF705EF7B1464140
106	Walmart Distribution Center	201 Old Elkhart Road	Palestine	TX	75801	US	Walmart's 5th DC. was originally built to 510,000 sq ft. Expanded in 1986. Converted into a Fashion DC in May 1994.	\N	893700	walmart	1981-03-01	0101000020E6100000EAC3C43071E757C00B410E4A98BD3F40
107	Walmart Distribution Center	152 North Old Highway 91	Hurricane	UT	84737	US	\N	\N	1170000	walmart	1993-12-01	0101000020E61000001E2F490AD15B5CC047663F9CD1944240
109	Walmart Distribution Center	8100 Zero Street	Fort Smith	AR	72903	US	Footwear distribution center.	\N	236100	walmart	1990-01-01	0101000020E6100000FB9C71D0149657C045F7072527A94140
110	Walmart Distribution Center	 	Brundidge	AL	\N	US	Swisslog automation in the Perishables complex.	\N	890000	walmart	2003-10-01	0101000020E6100000A18BE1453A7455C09B560A815CB83F40
111	Walmart Distribution Center	2701 Andrews Road	Opelika	AL	36801	US	Originally constructed to 450,000 sq ft.	\N	880000	walmart	2000-06-01	0101000020E6100000E748788CBC5455C0D5FC42D9A5594040
112	Walmart Distribution Center	3300 Sterlin Hurley Ind Highway	Clarksville	AR	72830	US	Originally a McLane's distribution center constructed to 750,000 sq ft.	\N	850000	walmart	1993-04-01	0101000020E6100000F07A1FFDE56157C0582DFA545FB74140
113	Walmart Distribution Center	868 West Peters Road	Casa Grande	AZ	85122	US	\N	\N	875100	walmart	2003-09-01	0101000020E6100000EFE6A90E39F15BC024E18CABDB6E4040
114	Walmart Distribution Center	6785 Southwest Enterprize Boulevard	Arcadia	FL	34269	US	Swisslog automation in the Perishables complex.	\N	940000	walmart	2005-02-01	0101000020E61000004E0B5EF4157D54C03C1405FA440A3B40
115	Walmart Distribution Center	2686 Commerce Road	Macclenny	FL	32063	US	\N	\N	880000	walmart	2002-04-01	0101000020E61000007E5EA747898554C0D6445502184B3E40
116	Walmart Distribution Center	5600 Highway 544	Winter Haven	FL	33881	US	\N	\N	1000000	walmart	1996-03-01	0101000020E6100000A6EECA2E986B54C0D1A45E0196123C40
157	Walmart Distribution Center	4250 Hamner Avenue	Eastvale	CA	91752	US	Walmart Import Center run by 3PL Schneider Logistics.	\N	755100	walmart	1999-08-01	0101000020E6100000804A95287B635DC0C729DFD858014140
117	Walmart Distribution Center	655 Unisia Drive	Monroe	GA	30655	US	Originally constructed as a Perishables DC at 480,000 sq ft . Added 400,000 sq ft of Dry Grocery space in 2006.	\N	880000	walmart	2000-07-01	0101000020E6100000A21C16B45AEB54C094895B0531E74040
118	Walmart Distribution Center	3801 U.S. 50	Olney	IL	62450	US	Originally constructed as a Perishables DC at 480,000 sq ft . Expanded in 2003.	\N	933100	walmart	1997-04-01	0101000020E6100000C53DF1F7660856C09A8B097B245B4340
119	Walmart Distribution Center	23769 Mathew Road	Sterling	IL	61081	US	Swisslog automation in the Perishables complex.	\N	1000000	walmart	2006-04-01	0101000020E6100000C246FE05A77256C0E3B89DC772E34440
120	Walmart Distribution Center	100 Fisher Parkway	Gas City	IN	46933	US	Swisslog automation in the Perishables complex.	\N	990000	walmart	2007-04-01	0101000020E61000006A166877486555C02FC37FBA813C4440
121	Walmart Distribution Center	3701 Russell Dyche Memorial Highway	London	KY	40741	US	Walmart's 3rd Grocery distribution center.	\N	867000	walmart	1995-09-01	0101000020E6100000521F926B540955C0DE718A8EE4924240
122	Walmart Distribution Center	45346 Parkway Boulevard	Robert	LA	70455	US	General Merchandise RDC built for $55 Million.	\N	850000	walmart	2001-02-01	0101000020E6100000DA3DD4119B9456C072D6F1A9AD823E40
123	Walmart Distribution Center	31 Alfred A Plourde Parkway	Lewiston	ME	04240	US	Originally constructed to 447,055 sq ft for Dry Grocery; Expanded to include Perishables in Apr 2007. Swisslog Automation in Perishables.	\N	892700	walmart	2005-01-01	0101000020E6100000EEAF1EF72D8C51C0C604EBEEF0074640
124	Walmart Distribution Center	5100 South Brookhart Drive	Harrisonville	MO	64701	US	\N	\N	850000	walmart	2001-07-01	0101000020E61000003067B62BF49657C07DC7951F5D4E4340
125	Walmart Distribution Center	973 Highway 30	New Albany	MS	38652	US	\N	\N	867000	walmart	1996-06-01	0101000020E6100000B0A998EF853E56C08EF85FF8D23F4140
126	Walmart Distribution Center	3001 East State Farm Road	North Platte	NE	69101	US	\N	\N	880000	walmart	2003-06-01	0101000020E6100000A6F2D13DC62E59C04620031EBD8B4440
127	Walmart Distribution Center	670 Los Morros Road	Los Lunas	NM	87031	US	\N	\N	750000	walmart	1999-02-01	0101000020E6100000F965D58C31B15AC0341477BCC9694140
128	Walmart Distribution Center	 	Sparks	NV	89434	US	\N	\N	890000	walmart	2006-08-01	0101000020E6100000F9D85DA024E55DC01E4A592B7FC44340
129	Walmart Distribution Center	300 Enterprise Road	Johnstown	NY	12095	US	\N	\N	868000	walmart	2000-01-01	0101000020E6100000220038F6EC9952C0DE8FDB2F9F7E4540
130	Walmart Distribution Center	1400 Old Chillicothe Road Southeast	Washington Court House	OH	43160	US	\N	\N	880000	walmart	2002-07-01	0101000020E610000095C84FF48AD954C01A88653387C24340
131	Walmart Distribution Center	843 Highway 43	Wintersville	OH	43953	US	\N	\N	880000	walmart	2003-06-01	0101000020E6100000AAD2BB1D062D54C009D51753FA2F4440
132	Walmart Distribution Center	 West 3000 Road	\N	OK	\N	US	Swisslog automation in the Perishables complex.	\N	893900	walmart	2005-04-01	0101000020E6100000DF5FF360C1F957C0CEF11B70A74A4240
133	Walmart Distribution Center	 South Indian Meridian Road	Pauls Valley	OK	73075	US	\N	\N	860000	walmart	2000-01-01	0101000020E61000000D77E4FED94F58C0FF870508305B4140
134	Walmart Distribution Center	 	Bedford	PA	15522	US	\N	\N	830000	walmart	1998-05-01	0101000020E6100000F4476293C6A253C0EBDF9AE040F64340
135	Walmart Distribution Center	390 Highridge Park Road	Pottsville	PA	17901	US	Swisslog automation in the Perishables complex.	\N	900000	walmart	2006-08-01	0101000020E610000050CF7124861453C054AC1A84B95D4440
136	Walmart Distribution Center	160 State Road S-13-682	Pageland	SC	29728	US	Facility was expanded in 2003.	\N	830000	walmart	1997-04-01	0101000020E6100000D345AFAB6E1A54C0CCE0DEEB5A664140
137	Walmart Distribution Center	285 Frank Martin Road	Shelbyville	TN	37160	US	Originally constructed as a Perishables facility of 370,000 sq ft. Facility was expanded in Nov 2005.	\N	850000	walmart	2001-02-01	0101000020E6100000CFA0A17F829D55C0179A907B5FC84140
138	Walmart Distribution Center	3470 Windmill Road	Cleburne	TX	76033	US	\N	\N	888000	walmart	2002-04-01	0101000020E6100000C04CCA935A5B58C028A902A4EC334040
139	Walmart Distribution Center	 	New Caney	TX	\N	US	Swisslog automation in the Perishables complex which has 75' High ceilings.	\N	901000	walmart	2003-05-01	0101000020E6100000320F4F6587CD57C07ACB3049C0273E40
140	Walmart Distribution Center	9605 Northwest H K Dodgen Loop	Temple	TX	76504	US	Perishables facility was expanded by 94,000 sq ft in 2001.	\N	850000	walmart	1993-09-01	0101000020E61000004A7B832F4C5758C02F19C748F6243F40
141	Walmart Distribution Center	5400 Highway 83	Corinne	UT	84307	US	Originally built to 984,000 sq ft in 1988 and later expanded in 1998.	\N	875000	walmart	2000-06-01	0101000020E6100000977329AE2A095CC09DD26641CDC74440
143	Walmart Distribution Center	546 Woodall Road	Grandview	WA	98930	US	Originally built to 700,000 sq ft and later expanded in 1998.	\N	880000	walmart	2004-04-01	0101000020E6100000E1B721C6EBFA5DC0E1E18794B0234740
144	Walmart Distribution Center	525 Industrial Avenue	Tomah	WI	54660	US	\N	\N	880000	walmart	2000-03-01	0101000020E6100000F26899FB1A9E56C0978BF84ECCFE4540
145	Walmart Distribution Center	426 Logistics Drive	Cheyenne	WY	82009	US	Swisslog automation in the Perishables complex.	\N	890000	walmart	2007-03-01	0101000020E6100000B9E34D7E8B395AC01D716D4D5F8F4440
146	Walmart Distribution Center	 	Parsons	WV	26287	US	\N	\N	\N	walmart	\N	0101000020E6100000FBF664B4C4E853C050447529649B4340
147	Walmart Distribution Center	1001 Columbia Avenue	Riverside	CA	92507	US	Freezer complex with 60,000 pallet positions that was leased in 2011 for 15 years.	\N	520000	walmart	2011-04-01	0101000020E6100000DC05949746555DC06FC5B42561004140
148	Walmart Distribution Center	1729 State Road 8	Auburn	IN	46706	US	\N	\N	400000	walmart	2001-01-01	0101000020E61000002A3BFDA02E4755C0221ADD41ECAE4440
149	Walmart Distribution Center	1309 U.S. 24	Moberly	MO	65270	US	\N	\N	450000	walmart	2002-05-01	0101000020E6100000841BDFCD091D57C0A760E86C5CB74340
150	Walmart Distribution Center	680 Vanco Mill Road	Henderson	NC	27537	US	\N	\N	400000	walmart	2002-04-01	0101000020E610000046A0B07A769853C0D421DC099B254240
151	Walmart Distribution Center	591 Apache Trail	Terrell	TX	75160	US	\N	\N	420000	walmart	2000-05-01	0101000020E61000000E4FAF94651558C0D05E2283815D4040
152	Walmart Distribution Center	 County Road 12	Mankato	MN	56001	US	Perishables distribution center with construction set to begin in 2014 and anticipated go-live in 2015.	\N	420000	walmart	2015-01-01	0101000020E61000006FE70CD6C97C57C06E2585C31C194640
153	Walmart Distribution Center	 	Mebane	NC	\N	US	Perishables distribution center with construction set to begin in 2015. Anticipated go-live in mid-2016. 450 jobs.	\N	450000	walmart	\N	0101000020E6100000CB715DE715D153C08DEC4ACB480C4240
154	Walmart Distribution Center	 	Parsons	WV	26287	US	\N	\N	\N	walmart	\N	0101000020E6100000FBF664B4C4E853C050447529649B4340
155	Walmart Distribution Center	13550 Valley Boulevard	Fontana	CA	92335	US	3PL Inland Cold Storage Owned and Operated.	\N	758000	walmart	2004-06-01	0101000020E610000081E84999D4605DC072C0AE264F094140
156	Walmart Distribution Center	4155 Wineville Avenue	\N	CA	91752	US	Sam's Club Import Center run by 3PL DAMCO.	\N	448000	walmart	2000-01-01	0101000020E6100000B75D68AED3625DC0A08A1BB798014140
158	Walmart Distribution Center	4100 Hamner Avenue	Eastvale	CA	91752	US	Walmart Import Center run by 3PL Schneider Logistics.	\N	901662	walmart	2000-01-01	0101000020E610000091B586527B635DC05000C5C892014140
159	Walmart Distribution Center	299 Aj Riggs Road	Statesboro	GA	30458	US	Started as a 1,700,000 sq ft DC and later expanded by 500,000 in 1999.	\N	2200000	walmart	1995-01-01	0101000020E6100000B02770A1617554C03E8743801D324040
160	Walmart Distribution Center	 Center Point Drive	Elwood	IL	60421	US	Walmart Import Center run by 3PL Schneider Logistics. Campus of 2 buildings 1.4 & 1.8 M sq ft.	\N	3400000	walmart	2006-06-01	0101000020E61000003ED983FF630856C07ADE8D0585B34440
161	Walmart Distribution Center	 Oscar Nelson Jr. Drive	Baytown	TX	77523	US	Walmart Import Center run by 3PL UTi Logistics. Campus of 2 buildings.	\N	4200000	walmart	2005-06-01	0101000020E6100000DB1BD71A25BA57C047BB1B5597B73D40
162	Walmart Distribution Center	9305 Pocahontas Trail	Williamsburg	VA	23185	US	Originally constructed to 1,000,000 sq ft and later expanded to 2,000,000 sq ft in Nov 2001 and again expanded by 1,000,000 sq ft in 2004-2005. Campus of 2 buildings.	\N	3000000	walmart	2000-10-01	0101000020E6100000ED2B0FD2532653C0C6D743A09F9A4240
163	Walmart Distribution Center	509 Southeast Martin Luther King Junior Parkway	Bentonville	AR	72712	US	\N	\N	18700	walmart	1994-01-01	0101000020E610000080F7E9D3058C57C04CD41C6A252F4240
164	Walmart Distribution Center	280 De Berry Street	Colton	CA	92324	US	Lineage Logistics operates this facility which is a public cold storage for local Southern California frozen food manufacturers.	\N	125800	walmart	2006-10-01	0101000020E610000039807EDF3F555DC03F975FBCD5034140
165	Walmart Distribution Center	11888 Mission Boulevard	\N	CA	91752	US	3PL is The Gilbert Company.	\N	599340	walmart	2009-05-01	0101000020E61000002A487DA3E7625DC081F2D2A81B034140
166	Walmart Distribution Center	600 Live Oak Avenue	Irwindale	CA	91706	US	3PL is MIQ Logistics.	\N	108850	walmart	2009-05-01	0101000020E6100000AA2B9FE5797F5DC05740A19E3E0E4140
167	Walmart Distribution Center	 	Conley	GA	\N	US	3PL is Exel Logistics.	\N	53360	walmart	2011-09-01	0101000020E6100000E3AAB2EF8A1555C0457EA257A8D14040
168	Walmart Distribution Center	6765 Imron Drive	Belvidere	IL	61008	US	Americold operates this facility which is a public cold storage facility.	\N	177800	walmart	2011-01-01	0101000020E6100000FE0DDAAB8F3856C0663387A416204540
169	Walmart Distribution Center	1340 141st Street	Hammond	IN	46327	US	3PL is Linc Logistics Insight Corp.	\N	150720	walmart	2011-07-01	0101000020E6100000934D5E09C9DF55C03205C655C0D14440
170	Walmart Distribution Center	423 Pitts School Road Northwest	Concord	NC	28027	US	3PL is Distribution Technology Inc.	\N	104380	walmart	2011-06-01	0101000020E6100000BBB0DAA1062C54C0380FCC762AB14140
171	Walmart Distribution Center	 	Tannersville	PA	\N	US	3PL is MIQ Logistics Inc.	\N	103700	walmart	2012-01-01	0101000020E6100000805C870F91D352C04D47A57D18854440
172	Walmart Distribution Center	1980 Getwell Road	Memphis	TN	38111	US	3PL is Linc Logistics Insight Corp.	\N	93100	walmart	2011-04-01	0101000020E61000002995F0845E7B56C0FCAA5CA8FC894140
173	Walmart Distribution Center	5210 Catron Drive	Dallas	TX	75227	US	Americold operates this facility which is a public cold storage facility.	\N	77000	walmart	2010-01-01	0101000020E610000088F2052D242B58C0C9022670EB644040
175	Target Distribution Center	5350 Mazzulli Court	Fontana	CA	92336	US	\N	\N	\N	target	\N	0101000020E6100000ED2AA4FC245D5DC09FDA2AD20E144140
176	Target Distribution Center	 William White Boulevard	Pueblo	CO	81001	US	\N	\N	\N	target	\N	0101000020E61000004BF8EF0BF9215AC0BE16F4DE18244340
177	Target Distribution Center	300-320 1st Street	Woodland	CA	95695	US	\N	\N	\N	target	\N	0101000020E6100000AFFC43447B715EC0A9B17389D9564340
178	Target Distribution Center	208 East 5th Street	Tifton	GA	31794	US	\N	\N	\N	target	\N	0101000020E610000030760CD98AE054C0963A6D324F733F40
179	Target Distribution Center	105-107 North Main Street	Oconomowoc	WI	53066	US	\N	\N	\N	target	\N	0101000020E61000000708E6E8F11F56C07B336ABE4A8E4540
180	Target Distribution Center	125-199 Southwest 2nd Avenue	Albany	OR	97321	US	\N	\N	\N	target	\N	0101000020E6100000BEE94C90C7C65EC0E65DF58079514640
181	Target Distribution Center	6201-6611 White Lick Creek Road	Indianapolis	IN	46231	US	\N	\N	\N	target	\N	0101000020E61000002816AEFDD39555C0539F9A8180D54340
182	Target Distribution Center	122 Draft Avenue	Stuarts Draft	VA	24477	US	\N	\N	\N	target	\N	0101000020E6100000C2A2224E27C253C0361E6CB1DB034340
183	Target Distribution Center	 Interstate 20	Tyler	TX	75704	US	\N	\N	\N	target	\N	0101000020E6100000817B9E3F6DDC57C063320BA30F3C4040
184	Target Distribution Center	551 New York 32	Schuylerville	NY	12871	US	\N	\N	\N	target	\N	0101000020E6100000800AECD6D76652C0F4D3C96317914540
185	Target Distribution Center	3310 Nansemond Parkway	Suffolk	VA	23434	US	\N	\N	\N	target	\N	0101000020E610000089B5F814002153C099D711876C664240
186	Target Distribution Center	101-133 North 8th Street	Midlothian	TX	76065	US	\N	\N	\N	target	\N	0101000020E61000009929ADBFA53F58C0FE6D0503BE3D4040
187	Target Distribution Center	61 Church Street	Amsterdam	NY	12010	US	\N	\N	\N	target	\N	0101000020E6100000B6A39300108C52C08051387128784540
188	Target Distribution Center	 Landon Nature Trail	Topeka	KS	66609	US	\N	\N	\N	target	\N	0101000020E610000048F0D0C1C4EB57C060F36041507D4340
189	Target Distribution Center	1-19 West Main Street	West Jefferson	OH	43162	US	\N	\N	\N	target	\N	0101000020E61000009E9ED21C34D154C06EABB420EFF84340
190	Target Distribution Center	3448 North Riverside Avenue	Rialto	CA	92377	US	\N	\N	\N	target	\N	0101000020E6100000081F4AB4E4595DC08258367348144140
191	Target Distribution Center	3448 North Riverside Avenue	Rialto	CA	92377	US	\N	\N	\N	target	\N	0101000020E6100000081F4AB4E4595DC08258367348144140
192	Target Distribution Center	 North Coastal Highway	Midway	GA	31320	US	\N	\N	\N	target	\N	0101000020E610000099BE32CA8E5B54C059F4F34B69CE3F40
193	Target Distribution Center	300-398 Lincoln Highway	DeKalb	IL	60115	US	\N	\N	\N	target	\N	0101000020E6100000AA1D0FC7043056C0C0D42A55FDF64440
194	Target Distribution Center	 Robert B. Miller, Jr. Road	Savannah	GA	31408	US	\N	\N	\N	target	\N	0101000020E61000006D59BE2E434C54C06FE305C71B124040
195	Target Distribution Center	701-799 Highway 16 Business	Newton	NC	28658	US	\N	\N	\N	target	\N	0101000020E61000003D3C951D2C4E54C08DFADAE9BDD54140
196	Target Distribution Center	1-99 Highway 100	Lake City	FL	32055	US	\N	\N	\N	target	\N	0101000020E6100000707209D1EBA854C028EFE3688E303E40
197	Target Distribution Center	1550 North 47th Avenue	Phoenix	AZ	85043	US	\N	\N	\N	target	\N	0101000020E6100000CA6FD1C9520A5CC0CA349A5C8CBB4040
198	Target Distribution Center	4464 Hemphill Street	Fort Worth	TX	76115	US	\N	\N	\N	target	\N	0101000020E610000051943AB73F5558C08AF9032F44574040
199	Target Distribution Center	1610 Washington Street	Cedar Falls	IA	50613	US	\N	\N	\N	target	\N	0101000020E61000008B187618931C57C009C4EBFA05434540
200	Target Distribution Center	 Valley Creek Road	Woodbury	MN	55125	US	\N	\N	\N	target	\N	0101000020E6100000ACD73E2E3B3C57C08D0E48C2BE754640
201	Target Distribution Center	10776 South Bear Table Tank Drive	Vail	AZ	85641	US	\N	\N	\N	target	\N	0101000020E610000076C58CF0F6AD5BC052280B5F5F074040
202	Target Distribution Center	 Tower Drive	Ontario	CA	91761	US	\N	\N	\N	target	\N	0101000020E61000002BE33A214F665DC021866753BF064140
203	Target Distribution Center	327-399 Church Street	Madison	AL	35758	US	\N	\N	\N	target	\N	0101000020E61000004F8358ECE5AF55C005BA9B4C81594140
204	Target Distribution Center	 Mill Street	Galesburg	MI	49053	US	\N	\N	\N	target	\N	0101000020E61000005077F931C15A55C050A335ABE3244540
205	Target Distribution Center	1550 North 47th Avenue	Phoenix	AZ	85043	US	\N	\N	\N	target	\N	0101000020E6100000CA6FD1C9520A5CC0CA349A5C8CBB4040
206	Target Distribution Center	101-171 Lincoln Highway	Chambersburg	PA	17201	US	\N	\N	\N	target	\N	0101000020E6100000C5A464DE4F6A53C0E28A30EAFFF74340
207	Target Distribution Center	1610 Washington Street	Cedar Falls	IA	50613	US	\N	\N	\N	target	\N	0101000020E61000008B187618931C57C009C4EBFA05434540
208	Target Distribution Center	 Jackson Avenue	Shafter	CA	93263	US	\N	\N	\N	target	\N	0101000020E61000007724A82B69D15DC04BFB308C05C04140
209	Target Distribution Center	922-936 Highway 34	Lugoff	SC	29078	US	\N	\N	\N	target	\N	0101000020E6100000B08ADC781C2C54C05E3CCD13191D4140
210	Target Distribution Center	1324 College Street Southeast	Lacey	WA	98503	US	\N	\N	\N	target	\N	0101000020E610000082380F27B0B45EC068BA8DBC62844740
339	Home Depot Rapid Deployment Center	6400 Jefferson Metro Parkway	McCalla	AL	35111	US		\N	\N	home depot	\N	0101000020E6100000CFD32588DFC155C0B1F1AA18F8A84040
340	Home Depot Distribution Center	7200 West Buckeye Road	Phoenix	AZ	85043	US		\N	\N	home depot	\N	0101000020E61000006F34DB70B30D5CC0F7AC6BB41CB84040
341	Home Depot Rapid Deployment Center	9081 West Washington Street	Tolleson	AZ	85353	US		\N	\N	home depot	\N	0101000020E610000072DF6A9D38105CC0C54CECEB0AB94040
342	Home Depot Distribution Center	300 South 55th Avenue	Phoenix	AZ	85043	US		\N	\N	home depot	\N	0101000020E610000047020D36750B5CC093510A5F04B94040
343	Home Depot Distribution Center	5450 East Francis Street	Ontario	CA	91761	US		\N	\N	home depot	\N	0101000020E6100000A1D1C20A5C625DC06B37B00BF5044140
344	Home Depot Distribution Center	14659 Alondra Boulevard	La Mirada	CA	90638	US		\N	\N	home depot	\N	0101000020E6100000DDBEFD6F5B815DC07885F4CAABF14040
345	Home Depot Distribution Center	 Encyclopedia Circle	Fremont	CA	94538	US		\N	\N	home depot	\N	0101000020E6100000308E80C0397F5EC025A886A2E5C14240
346	Home Depot Distribution Center	8535 Oakwood Place	Rancho Cucamonga	CA	91730	US		\N	\N	home depot	\N	0101000020E610000060A0B5ECDA635DC02D67A5FF9B0C4140
347	Home Depot Distribution Center	11650 Venture Drive	\N	CA	91752	US		\N	\N	home depot	\N	0101000020E610000025404D2D5B625DC0A243E048A0034140
348	Home Depot Rapid Deployment Center	5655 Ontario Mills Parkway	Ontario	CA	91764	US		\N	\N	home depot	\N	0101000020E61000006C393C29B8615DC0B6114F7633094140
349	Home Depot Rapid Deployment Center	1400 East Pescadero Avenue	Tracy	CA	95304	US		\N	\N	home depot	\N	0101000020E61000000BD5CDC5DF595EC0CA181F662FE14240
350	Home Depot Distribution Center	771 East Watson Center Road	Carson	CA	90745	US	Long Beach Transload Facility	\N	\N	home depot	\N	0101000020E61000000E6B2A8BC2905DC02E8D5F7825E94040
351	Home Depot Rapid Deployment Center	 River Bluff Avenue	Redlands	CA	92374	US		\N	\N	home depot	\N	0101000020E6100000514EB4AB104D5DC0786572C5200B4140
352	Home Depot Distribution Center	18300 Harlan Road	Lathrop	CA	95330	US		\N	\N	home depot	\N	0101000020E61000007AC6BE64E3525EC06610C41E7FE54240
353	Home Depot Distribution Center	19710 South Susana Road	Compton	CA	90221	US		\N	\N	home depot	\N	0101000020E6100000EF7618EE378D5DC0A1C1018816ED4040
354	Home Depot Distribution Center	9410 Heinze Way	Henderson	CO	80640	US		\N	\N	home depot	\N	0101000020E610000059C0046EDD375AC097B7D90EFCEE4340
355	Home Depot Distribution Center	170 Highland Park Drive	Bloomfield	CT	06002	US		\N	\N	home depot	\N	0101000020E61000005085E409292F52C0C1ADBB79AAEE4440
356	Home Depot Distribution Center	10205 Northwest 19th Street	Miami	FL	33172	US	Miami Export Center	\N	\N	home depot	\N	0101000020E61000005D5C99A63E1754C0EFA42A12B8CA3940
357	Home Depot Distribution Center	2900 North Andrews Avenue Extension	Pompano Beach	FL	33064	US		\N	\N	home depot	\N	0101000020E6100000454B1E4FCB0854C02B357BA015443A40
358	Home Depot Distribution Center	8423 Sunstate Street	Tampa	FL	33634	US		\N	\N	home depot	\N	0101000020E6100000E204A6D3BAA154C00ABDFE243E073C40
359	Home Depot Distribution Center	4831 Bulls Bay Highway	Jacksonville	FL	32219	US		\N	\N	home depot	\N	0101000020E610000005210F336A7254C08F37F92D3A613E40
360	Home Depot Distribution Center	3010 Saddle Creek Road	Lakeland	FL	33805	US		\N	\N	home depot	\N	0101000020E61000002CF6F296867954C01EFE9AAC51133C40
361	Home Depot Distribution Center	180 Westridge Parkway	McDonough	GA	30253	US		\N	\N	home depot	\N	0101000020E6100000572F7546CA0C55C0529ACDE330B44040
362	Home Depot Distribution Center	190 Greenwood Industrial Parkway	Locust Grove	GA	30248	US		\N	\N	home depot	\N	0101000020E6100000C98E3287490A55C0D5DEF137EBB14040
363	Home Depot Rapid Deployment Center	6201 Peterson Road	Lake Park	GA	31636	US		\N	\N	home depot	\N	0101000020E61000003688201851CC54C091459A7807AA3E40
364	Home Depot Distribution Center	155 Alcovy Ind Boulevard	Dacula	GA	30019	US		\N	\N	home depot	\N	0101000020E6100000CC6FE2F5AAFB54C0D9F80269B5FD4040
365	Home Depot Distribution Center	125 Crossroads Parkway	Savannah	GA	31407	US		\N	\N	home depot	\N	0101000020E6100000F1BBE9961D4D54C0E19BA6CF0E144040
366	Home Depot Distribution Center	 Logistics Drive	Elwood	IL	60421	US		\N	\N	home depot	\N	0101000020E61000002256DA3DD40856C052A9C8D754B84440
367	Home Depot Rapid Deployment Center	2950 Centerpoint Way	Joliet	IL	60436	US		\N	\N	home depot	\N	0101000020E6100000190DCF01380956C0C1583A7A57B84440
368	Home Depot Distribution Center	1000 Knell Road	Montgomery	IL	60538	US		\N	\N	home depot	\N	0101000020E61000005ABBED42731656C0E0A128D027DE4440
369	Home Depot Distribution Center	1390 Perry Road	Plainfield	IN	46168	US		\N	\N	home depot	\N	0101000020E61000008DA4935BC99655C04650EBEC1AD84340
370	Home Depot Rapid Deployment Center	5200 Southwest Wenger Street	Topeka	KS	66609	US		\N	\N	home depot	\N	0101000020E6100000D430D7FDBEEC57C01318A18E7D7C4340
371	Home Depot Distribution Center	835 Pride Drive	Hammond	LA	70401	US		\N	\N	home depot	\N	0101000020E610000026E6B4021E9B56C06B0597D8C6853E40
372	Home Depot Distribution Center	16500 Hunters Green Parkway	Hagerstown	MD	21740	US		\N	\N	home depot	\N	0101000020E6100000AE9E93DE377353C0AEB9A3FFE5D04340
373	Home Depot Distribution Center	7100 Holladay Tyler Road	Glenn Dale	MD	20769	US		\N	\N	home depot	\N	0101000020E61000007262597AFE3353C0D82D02637D7E4340
374	Home Depot Distribution Center	625 University Avenue	Norwood	MA	02062	US		\N	\N	home depot	\N	0101000020E6100000FD55DBA8A9CA51C0936E4BE482194540
375	Home Depot Rapid Deployment Center	 Campanelli Drive	Westfield	MA	01085	US		\N	\N	home depot	\N	0101000020E61000009AA1A7B7F52E52C071033E3F8C154540
376	Home Depot Distribution Center	38481 Huron River Drive	Romulus	MI	48174	US		\N	\N	home depot	\N	0101000020E61000007D48AE51C5DA54C03C832B45971B4540
377	Home Depot Distribution Center	722 Kasota Circle Southeast	Minneapolis	MN	55414	US		\N	\N	home depot	\N	0101000020E6100000BD1B0B0A834D57C0F0F78BD9927D4640
378	Home Depot Distribution Center	9215 Riverview Drive	St. Louis	MO	63137	US		\N	\N	home depot	\N	0101000020E6100000925CFE43FA8D56C05F268A90BA5D4340
379	Home Depot Distribution Center	61 North Station Road	Cranbury Township	NJ	08512	US		\N	\N	home depot	\N	0101000020E610000011E335AF6AA052C03E7958A835274440
380	Home Depot Distribution Center	130 Interstate Boulevard	East Brunswick	NJ	08816	US		\N	\N	home depot	\N	0101000020E610000064E597C1989C52C0EDD632198E324440
381	Home Depot Distribution Center	130 Docks Corner Road	Dayton	NJ	08810	US		\N	\N	home depot	\N	0101000020E61000009721E92EE49E52C0558E249C712F4440
382	Home Depot Distribution Center	2359 Center Square Road	Swedesboro	NJ	08085	US		\N	\N	home depot	\N	0101000020E6100000350BB43BA4D852C0A4AA09A2EEE34340
383	Home Depot Distribution Center	601 Neelytown Road	Montgomery	NY	12549	US		\N	\N	home depot	\N	0101000020E6100000DA006C40848F52C011E15F048DBF4440
384	Home Depot Distribution Center	501 Black Satchel Drive	Charlotte	NC	28216	US		\N	\N	home depot	\N	0101000020E6100000BC07E8BE9C3854C0F2237EC51AA44140
385	Home Depot Distribution Center	30301 Carter Street	Solon	OH	44139	US		\N	\N	home depot	\N	0101000020E6100000F53691F4C45D54C03D7D04FEF0B04440
386	Home Depot Rapid Deployment Center	1980 Township Road 14	Van Buren	OH	45889	US		\N	\N	home depot	\N	0101000020E61000004503C2983EEA54C0EDA7B51FDF914440
387	Home Depot Rapid Deployment Center	500 Gateway Boulevard	Monroe	OH	45050	US		\N	\N	home depot	\N	0101000020E6100000422F922C961455C06B662D05A4B74340
388	Home Depot Rapid Deployment Center	4999 Depot Court Southeast	Salem	OR	97317	US		\N	\N	home depot	\N	0101000020E61000006BF294D574BD5EC0F20703CFBD734640
389	Home Depot Rapid Deployment Center	300 Enterprise Way	Pittston	PA	18643	US		\N	\N	home depot	\N	0101000020E61000004D6B2E92D1F052C019703BD972A84440
390	Home Depot Rapid Deployment Center	 Willard Drive	Breinigsville	PA	18031	US		\N	\N	home depot	\N	0101000020E610000063D927DB1BE852C069A0432AD6464440
391	Home Depot Distribution Center	861 Nestle Way	Breinigsville	PA	18031	US		\N	\N	home depot	\N	0101000020E61000008CF84ECC7AE952C08E942D9276494440
392	Home Depot Rapid Deployment Center	420 Foster Brothers Drive	West Columbia	SC	29172	US		\N	\N	home depot	\N	0101000020E6100000FC9AF6DEA94454C015E7035D56F44040
393	Home Depot Distribution Center	1701 North Claton Drive	Columbia	TN	38401	US		\N	\N	home depot	\N	0101000020E6100000C311A452ECC055C0AE47E17A14D64140
394	Home Depot Distribution Center	2320 Beckleymeade Avenue	Dallas	TX	75232	US		\N	\N	home depot	\N	0101000020E6100000D284926E703658C0EB634F4C28514040
395	Home Depot Distribution Center	2200 Business Interstate 45-F	Corsicana	TX	75110	US		\N	\N	home depot	\N	0101000020E610000089D92670C61D58C071506793680F4040
396	Home Depot Rapid Deployment Center	2315 Danieldale Road	Dallas	TX	75232	US		\N	\N	home depot	\N	0101000020E6100000737511F0353658C0EEB1F4A10B514040
397	Home Depot Rapid Deployment Center	18100 Chisholm Trail	Houston	TX	77060	US		\N	\N	home depot	\N	0101000020E6100000780B24287ED957C0F27A30293EF63D40
398	Home Depot Distribution Center	1102 Highway 161	Grand Prairie	TX	75051	US		\N	\N	home depot	\N	0101000020E6100000213CDA38624158C050A8A78FC05C4040
399	Home Depot Distribution Center	6115 FM 1405 Road	Baytown	TX	77523	US		\N	\N	home depot	\N	0101000020E610000061889CBE9EBA57C015713AC956BB3D40
400	Home Depot Distribution Center	10815 Sentinel Street	San Antonio	TX	78217	US		\N	\N	home depot	\N	0101000020E61000001898158A749C58C0BB2473D1358A3D40
401	Home Depot Rapid Deployment Center	8103 Fallbrook Drive	Houston	TX	77064	US		\N	\N	home depot	\N	0101000020E6100000D085EC17C7E157C0DA6A7B606CEC3D40
402	Home Depot Distribution Center	1101 Industrial Park Drive	Layton	UT	84041	US		\N	\N	home depot	\N	0101000020E61000003DAF1D311FFF5BC0DA0FC2ED1A894440
403	Home Depot Rapid Deployment Center	480 Park Center Drive	Winchester	VA	22603	US		\N	\N	home depot	\N	0101000020E610000039454772F98853C0C003A84EAC994340
404	Home Depot Distribution Center	 Maranto Manor Drive	Winchester	VA	22602	US		\N	\N	home depot	\N	0101000020E6100000BCC2CC889C8953C019DE5108898A4340
405	Home Depot Distribution Center	8800 South 190th Street	Kent	WA	98031	US		\N	\N	home depot	\N	0101000020E610000060915F3F448E5EC0A66BDC5152B74740
406	Home Depot Distribution Center	9303 Orion Drive Northeast	Lacey	WA	98516	US		\N	\N	home depot	\N	0101000020E61000000F9C33A2B4AF5EC0C7F07D16F0884740
407	Home Depot Distribution Center	2301 Taylor Way	Tacoma	WA	98421	US		\N	\N	home depot	\N	0101000020E6100000CE14DFF53E985EC05E13D21A83A24740
\.


--
-- Name: warehouse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: el
--

SELECT pg_catalog.setval('warehouse_id_seq', 407, true);


--
-- Data for Name: warehouse_type; Type: TABLE DATA; Schema: public; Owner: el
--

COPY warehouse_type (id, name) FROM stdin;
1	GMDCDistributionCenter
2	Sam's ClubDistributionCenter
3	SpecialtyWalmartDistributionCenters
4	ClosedWalmartDistributionCenters
5	FashionDistributionCenter
6	Full-Line GroceryDistributionCenter
7	ImportDistributionCenter
8	Center PointDistributionCenters
9	Target Distribution Center
10	Kroger Distribution Center
11	Costco Distribution Center
12	Walgreens Distribution Center
13	Amazon Distribution Center
14	Home Depot Rapid Deployment Center
15	Home Depot Distribution Center
\.


--
-- Name: warehouse_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: el
--

SELECT pg_catalog.setval('warehouse_type_id_seq', 15, true);


--
-- Data for Name: warehouse_walmart; Type: TABLE DATA; Schema: public; Owner: el
--

COPY warehouse_walmart (warehouse, walmart) FROM stdin;
1	1
2	2
3	3
4	4
5	5
6	6
7	7
8	8
9	9
10	10
11	11
12	12
13	13
14	14
15	15
16	16
17	17
18	18
19	19
20	20
21	21
22	22
23	23
24	24
25	25
26	26
27	27
28	28
29	29
30	30
31	31
32	32
33	33
34	34
35	35
36	36
37	37
38	38
39	39
40	40
41	41
42	42
43	43
44	44
45	45
46	46
47	47
48	48
49	49
50	50
51	51
52	52
53	53
54	54
55	55
56	56
57	57
58	58
59	59
60	60
61	61
62	62
63	63
64	64
65	65
66	66
67	67
68	68
69	69
71	70
72	71
73	72
74	73
75	74
76	75
77	76
78	77
79	78
80	79
81	80
82	81
83	82
84	83
87	84
88	85
89	86
90	87
93	88
96	89
97	90
98	91
99	92
100	93
101	94
102	95
103	96
104	97
105	98
106	99
107	100
108	101
109	102
110	103
111	104
112	105
113	106
114	107
115	108
116	109
117	110
118	111
119	112
120	113
121	114
122	115
123	116
124	117
125	118
126	119
127	120
128	121
129	122
130	123
131	124
132	125
133	126
134	127
135	128
136	129
137	130
138	131
139	132
140	133
141	134
142	135
143	136
144	137
145	138
146	139
147	140
148	141
149	142
150	143
151	144
152	145
153	146
154	147
155	148
156	149
157	150
158	151
159	152
160	153
161	154
162	155
163	156
164	157
165	158
166	159
167	160
168	161
169	162
170	163
171	164
172	165
173	166
\.


--
-- PostgreSQL database dump complete
--

