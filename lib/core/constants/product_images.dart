class ProductImages {
  ProductImages._();

  static const _base = 'https://images.unsplash.com/photo-';
  static const _card = '?w=600&h=400&fit=crop&q=80&auto=format';
  static const _detail = '?w=1200&h=800&fit=crop&q=80&auto=format';
  static const _banner = '?w=1400&h=500&fit=crop&q=80&auto=format';

  static String _c(String id) => '$_base$id$_card';
  static String _d(String id) => '$_base$id$_detail';

  static const String heroBanner = '${_base}1564078516393-cf04bd966897$_banner';

  static const String heroBanner2 =
      '${_base}1785535573662-417e82193598$_banner';

  static String? forProduct(String productId, {bool detail = false}) {
    final id = _photoIds[productId];
    if (id == null) return null;
    return detail ? _d(id) : _c(id);
  }

  static String? forStyle(String styleId) {
    final id = _stylePhotoIds[styleId];
    if (id == null) return null;
    return _c(id);
  }

  static String? forRoom(String roomId) {
    final id = _roomPhotoIds[roomId];
    if (id == null) return null;
    return _c(id);
  }

  static String? forCollection(String collectionId) {
    final id = _collectionPhotoIds[collectionId];
    if (id == null) return null;
    return _c(id);
  }

  static const Map<String, String> _stylePhotoIds = {
    'scandinavian': '1583847268964-b28dc8f51f92',
    'japandi': '1605774337664-7a846e9cdf17',
    'contemporary': '1616137422495-1e9e46e2aa77',
    'minimalist': '1625585598750-3535fe40efb3',
    'industrial': '1767706508383-097054618007',
    'mid_century_modern': '1600210492493-0946911123ea',
    'modern_luxury': '1618221195710-dd6b41faaea6',
    'bohemian': '1616046229478-9901c5536a45',
    'rustic': '1631724604275-af3bbb5c904d',
    'mediterranean': '1672865362636-2a1c08284ede',
    'traditional': '1533477579100-e9a9fdf5be71',
    'eclectic': '1631509716275-59e9d106504a',
  };

  static const Map<String, String> _roomPhotoIds = {
    'room_001': '1583847268964-b28dc8f51f92',
    'room_002': '1778731525306-6e61638ff245',
    'room_003': '1564078516393-cf04bd966897',
    'room_004': '1781794902242-f8578908d640',
    'room_005': '1632829882891-5047ccc421bc',
    'room_006': '1560448204-e02f11c3d0e2',
    'room_007': '1776482128012-a47f853abd57',
    'room_008': '1554995207-c18c203602cb',
    'room_009': '1560185893-a55cbc8c57e8',
    'room_010': '1616486029423-aaa4789e8c9a',
    'room_011': '1556020685-ae41abfc9365',
    'room_012': '1696762932825-2737db830bbe',
    'room_013': '1616594092403-fb65629b0a46',
    'room_014': '1757344454333-cc666252e596',
    'room_015': '1600489000022-c2086d79f9d4',
    'room_016': '1502005097973-6a7082348e28',
    'room_017': '1610177534644-34d881503b83',
    'room_018': '1512916194211-3f2b7f5f7de3',
    'room_019': '1656403002413-2ac6137237d6',
    'room_020': '1600488999806-8efb986d87b1',
    'room_021': '1593136596203-7212b076f4d2',
    'room_022': '1560185007-cde436f6a4d0',
    'room_023': '1600494603989-9650cf6ddd3d',
    'room_024': '1595846723416-99a641e1231a',
    'room_025': '1595846519845-68e298c2edd8',
    'room_026': '1697807665472-908cfe732b8e',
    'room_027': '1576698483491-8c43f0862543',
    'room_028': '1742134131017-44d377a611b1',
    'room_029': '1572742482459-e04d6cfdd6f3',
    'room_030': '1722923400899-af08ffc715c6',
  };

  static const String studioBanner =
      '${_base}1611269154421-4e27233ac5c7$_banner';

  static String? forTemplate(String templateId) {
    final id = _templatePhotoIds[templateId];
    if (id == null) return null;
    return _c(id);
  }

  static const Map<String, String> _templatePhotoIds = {
    'template_001': '1763827513396-5917fc6c84f3',
    'template_002': '1786051376076-9ff627bcdcba',
    'template_003': '1625585598750-3535fe40efb3',
    'template_004': '1616046229478-9901c5536a45',
    'template_005': '1644057501622-dfa7dd26dbfb',
    'template_006': '1648634158203-199accfd7afc',
    'template_007': '1699869653495-fe26f4c70b3e',
    'template_008': '1725257928373-dc6d2ac7b145',
    'template_009': '1592506119503-c0b18879bd5a',
    'template_010': '1773754624815-17c169b8bb6b',
    'template_011': '1706820229870-f9a8c6dac193',
    'template_012': '1613685303404-19f881533316',
    'template_013': '1625496015040-2f461a6a717b',
    'template_014': '1560448205-4d9b3e6bb6db',
    'template_015': '1724582586458-a51791349977',
  };

  static const Map<String, String> _collectionPhotoIds = {
    'coll_001': '1583847268964-b28dc8f51f92',
    'coll_002': '1600494603989-9650cf6ddd3d',
    'coll_003': '1560185893-a55cbc8c57e8',
    'coll_004': '1564078516393-cf04bd966897',
    'coll_005': '1632829882891-5047ccc421bc',
    'coll_006': '1600489000022-c2086d79f9d4',
    'coll_007': '1767706508383-097054618007',
    'coll_008': '1672865362636-2a1c08284ede',
    'coll_009': '1560448204-e02f11c3d0e2',
    'coll_010': '1605774337664-7a846e9cdf17',
  };

  static const Map<String, String> _photoIds = {
    // Sofas
    'sofa_001': '1555041469-a586c61ea9bc',
    'sofa_002': '1698936061086-2bf99c7b9fc5',
    'sofa_003': '1512212621149-107ffe572d2f',
    'sofa_004': '1590251024078-8a6d9f90b02d',
    'sofa_005': '1634497885778-152eb6fd543d',
    'sofa_006': '1759722665629-29df6ee4f9a5',
    'sofa_007': '1633505899118-4ca6bd143043',
    'sofa_008': '1623353283172-2518d7e6f5ab',
    'sofa_009': '1601392740426-907c7b028119',
    'sofa_010': '1647221598498-245f6ed6c720',
    'sofa_011': '1680702699412-7df12ead8846',
    'sofa_012': '1653242370330-5e3f3f579f7c',

    // Beds
    'bed_001': '1505693416388-ac5ce068fe85',
    'bed_002': '1779903726446-6f796d533d47',
    'bed_003': '1522771739844-6a9f6d5f14af',
    'bed_004': '1765862835319-18fb6f8caff6',
    'bed_005': '1616486029423-aaa4789e8c9a',
    'bed_006': '1556020685-ae41abfc9365',
    'bed_007': '1778731525620-ae459167c176',
    'bed_008': '1617098900591-3f90928e8c54',
    'bed_009': '1774578342100-f779e988c83d',
    'bed_010': '1757417983938-2c2a931d41aa',
    'bed_011': '1588046130717-0eb0c9a3ba15',
    'bed_012': '1696762932825-2737db830bbe',

    // Chairs
    'chair_001': '1598300042247-d088f8ab3a91',
    'chair_002': '1506439773649-6e0eb8cfb237',
    'chair_003': '1612372606404-0ab33e7187ee',
    'chair_004': '1581539250439-c96689b516dd',
    'chair_005': '1617806118233-18e1de247200',
    'chair_006': '1592078615290-033ee584e267',
    'chair_007': '1602872030490-4a484a7b3ba6',
    'chair_008': '1640938776314-4d303f8a1380',
    'chair_009': '1699588772787-1eed3b726e0a',
    'chair_010': '1638285852125-c6ed00ff2065',
    'chair_011': '1634712282287-14ed57b9cc89',
    'chair_012': '1650476524564-f94dc9669067',

    // Tables
    'table_001': '1605239435870-67df4c54a0b3',
    'table_002': '1643558544531-bff73bbffc28',
    'table_003': '1771817239657-1b66cc1f7d23',
    'table_004': '1777513538143-8525eb3943f6',
    'table_005': '1679558879549-433b75ae99f0',
    'table_006': '1777472684123-43232b907fdf',
    'table_007': '1758977404683-d04c315a005b',
    'table_008': '1773916755745-e7cb058fc402',
    'table_009': '1786943311801-e79df5fd076b',
    'table_010': '1758977403865-f79e156415b3',
    'table_011': '1739519062410-9a15a148f626',
    'table_012': '1785493911940-09a530e887e8',

    // Storage
    'storage_001': '1593430980369-68efc5a5eb34',
    'storage_002': '1605116959031-6e2d13a2ee56',
    'storage_003': '1611486212557-88be5ff6f941',
    'storage_004': '1603745676022-d1b77e3cbce8',
    'storage_005': '1536411396596-afed9fa3c1b2',
    'storage_006': '1594620302200-9a762244a156',
    'storage_007': '1608610025929-c9f376a28c04',
    'storage_008': '1528208079124-a2387f039c99',
    'storage_009': '1542713504-03db5fb21c66',
    'storage_010': '1633813122125-882b7cba1f7f',
    'storage_011': '1708161885729-63faff807840',
    'storage_012': '1580628881159-4eae247a6bf5',

    // Lighting
    'light_001': '1606170033648-5d55a3edf314',
    'light_002': '1540932239986-30128078f3c5',
    'light_003': '1565814329452-e1efa11c5b89',
    'light_004': '1475783006851-1d68dd683eff',
    'light_005': '1515948725-edac7b5bb0fc',
    'light_006': '1636368208791-17b81ed832d2',
    'light_007': '1592622515232-6e3e2a0d3d9a',
    'light_008': '1513506003901-1e6a229e2d15',
    'light_009': '1552529232-9e6cb081de19',
    'light_010': '1718221621618-e477ce33485a',
    'light_011': '1531776691428-a0096d20137c',
    'light_012': '1630806293051-7b66c27ec042',

    // Rugs
    'rug_001': '1660394585016-508f949df960',
    'rug_002': '1762356317094-5826049a3641',
    'rug_003': '1588421874990-1fe162747f9b',
    'rug_004': '1767159601823-96d0295344ce',
    'rug_005': '1594040226829-7f251ab46d80',
    'rug_006': '1652634213812-f0deeb1de78e',
    'rug_007': '1774215915840-22cd38b8bd0e',
    'rug_008': '1671576563965-23993d69eb17',
    'rug_009': '1765454359095-ed30cd9eb6ea',
    'rug_010': '1534889156217-d643df14f14a',
    'rug_011': '1764836168197-3aa3a890a0f0',
    'rug_012': '1599503815079-dfb7085fc667',

    // Decor
    'decor_001': '1612196808214-b8e1d6145a8c',
    'decor_002': '1762969217496-32d784e7e557',
    'decor_003': '1631125915902-d8abe9225ff2',
    'decor_004': '1772992552245-eb3ab1539c6f',
    'decor_005': '1582131503261-fca1d1c0589f',
    'decor_006': '1597696929736-6d13bed8e6a8',
    'decor_007': '1775007873682-46d44284ae12',
    'decor_008': '1588874133473-d6d9c9dd4f31',
    'decor_009': '1772630204917-5e649dcb0d68',
    'decor_010': '1584589167171-541ce45f1eea',
    'decor_011': '1775644933601-db1a82ac709a',
    'decor_012': '1603178455924-ef33372953bb',

    // Cabinets
    'cabinet_001': '1786886382297-b3d20435bc20',
    'cabinet_002': '1601760561441-16420502c7e0',
    'cabinet_003': '1701421047855-d7bafd8d6f69',
    'cabinet_004': '1609241506098-80fc37c6325f',
    'cabinet_005': '1772567732993-ef3c4acde6c3',
    'cabinet_006': '1758565811438-23e44c7c65fa',
    'cabinet_007': '1773579223066-4b54a17ec8cc',
    'cabinet_008': '1665507279638-5b48073c637b',
    'cabinet_009': '1610733374054-59454fe657cd',
    'cabinet_010': '1785535694900-b8199f0494be',
    'cabinet_011': '1601760561441-16420502c7e0',
    'cabinet_012': '1609241506098-80fc37c6325f',

    // Outdoor
    'outdoor_001': '1613685302957-3a6fc45346ef',
    'outdoor_002': '1766603636772-52b1273c655d',
    'outdoor_003': '1623625434531-d130448273c1',
    'outdoor_004': '1769502963760-ea942f2d1fe7',
    'outdoor_005': '1602860739945-9a61573cd62d',
    'outdoor_006': '1621506821957-1b50ab7787a4',
    'outdoor_007': '1613317447829-eea2ed59640f',
    'outdoor_008': '1617887021567-fe8d2480bd96',
    'outdoor_009': '1629078692974-a778fc29497b',
    'outdoor_010': '1632830196000-d8a1abf32691',
    'outdoor_011': '1600210492090-a159ffa3aeaf',
    'outdoor_012': '1766603636766-1f4662469448',
  };
}
