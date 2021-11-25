hw_base_urls = ["https://dlsn-cdn-hw.dashenq.com/hwandroid/", "https://lwcs2cdn.dashenq.com/hwandroid/"]
tx_base_urls = ["https://lwcs2cdn.dashenq.com/txandroid/", "https://dlsn-cdn-hw.dashenq.com/txandroid/"]

hw_packs = ['35cd04c6da947c2cde5ab2aaa2ea0f8f.7z', 'd1e1c08487335107fe316ba4077521f2.7z', '2af342bac5baadab5b73824a09fa07b7.7z', '0a156bb37620b7f82bc2e2737cdd5de3.7z', '81fb4319b0c1a22105a3cfdb4f25426f.7z', '6652071e21a91f8c8fba37000031dfaa.7z', '7207e0b4cfb6c31cc9e46bd26a4daf74.7z', 'e7dece463e58f2cc543445c464cf17d2.7z', '1c046002a5d35582198f92d9ff6726e0.7z', '594999d93aa9809226bd0a5bc6611a1d.7z', '3b86d2c49232cf7443cdf6691f147a96.7z', '069678465d66df166046435aef990e14.7z', '58be3b0e334a71a417f6db1a8f4bd8bf.7z', '84ba3c3270100f80fda8fd20ae5943a6.7z', 'fe9024b9eed5cc8ba8d92e1f8189f146.7z', '0da0d3eaaa39dea93144ef9c1ec12588.7z', 'b77038eb44bb7af00ee81399c43bb8d2.7z', '9e45b929fe3412d45c972a92424d1c24.7z', '2467e67d461fd6ce13a43eb2ff6e4a43.7z', '8dd908bf7671a93e71743c1934333b8f.7z', '2b01fac0d36563ad4941831402d06bc6.7z', '4ff1ec6b514de4e5f85050d7be2e7bf8.7z', '98820dbbfe58acb30ad7604950cd183c.7z', 'cbed456fd1651880564cd12fde002a29.7z', '2d2015e2fd20df0082cfaca89ff6222c.7z', 'a377fd2db810c169b66b48e951cedf07.7z', 'bcebe20f6dc824e1f74ce72656f5178e.7z', '521adad38553bd0f43c7d39e0d6ca7c2.7z', '8b335dfaeeb63a390a81c2efedd9eddf.7z', '22f1b6c62f757a75000e14e167f85cee.7z'] 
tx_packs =  ['9d2ef81458f3758ec2f2e566ef8d50e2.7z', '49844849e08c721fb067cdbdf2892b97.7z', '0aa3d6be78bc42c1b2bede5d8ff22f71.7z', '2407f1e98a75eb88a9b810958af591dc.7z', '6c40ca08bcf530ce0a0385479bff2ff7.7z', '73088f855edcab3dd4b0581b8e02964b.7z', '1ad2561c88a647f857dbc50dd9fc772b.7z', '67668b1dfbcffa4f7ae788c239c5d5a9.7z', '9b348f4d98900b9492d4ca1ae19d95bb.7z', 'bed95de47fdf7e2e099eedfa31a72a63.7z', '6df0bf633d30a31f1b232c1ee317a420.7z', '1e160606d94c1a901a99859c9040e39b.7z', '0772e22977d9292222d469f7aece24b8.7z', 'e988387b931cea5921b2824777375683.7z', '2fd705b127744257b5f0c416d78fc85a.7z', 'a7d419e981d64a79a539cc8909ed9093.7z', 'e05b9c10fd5b8dbd645a1d451ceb25f0.7z', '3ed464c196b76f955764a81bcb0c747d.7z', 'a50e2d8571b82d2b3ba09ffc6913b252.7z', '6185ba5ba08746ed358c7bfc629df48e.7z', '73047d73f051bed41ed3e36ec706476f.7z', '90eea8d25676f36219356118f68bab94.7z', '178ca871d63e02136ac972217559ddb5.7z', '966e178ac51aab4f8591e5c6fd9cd28e.7z']

for url in hw_base_urls:
    for pack in hw_packs:
        print(url + pack)
    print('HW: {}'.format(len(hw_packs)))

for url in tx_base_urls:
    for pack in tx_packs:
        print(url + pack)
    print('TX: {}'.format(len(tx_packs)))
