INSERT INTO `e_channel` VALUES ('0', 'all', 'ȫ��', '', null, '0', null, '1');
INSERT INTO `e_channel` VALUES ('1', 'food', '��ʳ', '', null, '1', null, '1');
INSERT INTO `e_channel` VALUES ('2', 'clothes', '��װ', '', null, '2', null, '1');
INSERT INTO `e_channel` VALUES ('3', 'beauty', '��ױ', '', null, '3', null, '1');
INSERT INTO `e_channel` VALUES ('40', 'baby', 'ĸӤ', 'baby.html', null, '4', null, '0');
INSERT INTO `e_channel` VALUES ('41', 'computer', '����', 'computer.html', null, '5', null, '0');
INSERT INTO `e_channel` VALUES ('42', 'book', '���', 'book.html', null, '6', null, '0');
INSERT INTO `e_channel` VALUES ('43', 'furniture\r\nfurniture', '�Ҿ�', null, null, '7', null, '1');


-- ----------------------------
-- Records of e_module
-- ----------------------------
INSERT INTO `e_module` VALUES ('101', 'friends', '����Ȧ', 'img/friend.png', 'friends.html', null, '0', 'discover', '1');
INSERT INTO `e_module` VALUES ('102', 'radar', '�״�', 'img/radar.png', 'radar.html', null, '1', 'discover', '1');
INSERT INTO `e_module` VALUES ('103', 'recommend', '�Ƽ�', 'img/recommend.png', 'recommend.html', null, '2', 'discover', '0');
INSERT INTO `e_module` VALUES ('104', 'hot', '����', 'img/hot.png', 'hot.html', null, '3', 'discover', '0');
INSERT INTO `e_module` VALUES ('105', 'compare', '�ȼ�', 'img/compare.png', null, null, '4', 'discover', '0');
INSERT INTO `e_module` VALUES ('106', 'join', 'ƴ��', 'img/join.png', null, null, '5', 'discover', '0');
INSERT INTO `e_module` VALUES ('201', 'settings', '����', 'img/settings.png', 'settings.html', null, '0', 'me', '1');
INSERT INTO `e_module` VALUES ('202', 'contact_list', 'ͨѶ¼', 'img/add_friend.png', 'contact_list.html', null, '1', 'me', '1');
INSERT INTO `e_module` VALUES ('203', 'my_favorite', '�ҵ��ղ�', 'img/favorite.png', 'my_favorite.html', null, '2', 'me', '1');
INSERT INTO `e_module` VALUES ('204', 'my_share', '�ҵķ���', 'img/share.png', 'my_share.html', null, '3', 'me', '1');
INSERT INTO `e_module` VALUES ('205', 'my_shop', '�ҵĵ���', 'img/my_shop.png', 'my_shop.html', null, '4', 'me', '1');
INSERT INTO `e_module` VALUES ('206', 'my_grade', '�ҵĻ���', 'img/my_grade.png', 'my_grade.html', null, '5', 'me', '1');
INSERT INTO `e_module` VALUES ('207', 'my_message', '�ҵ���Ϣ', null, null, null, '6', 'me', '1');


-- ----------------------------
-- Records of e_setting
-- ----------------------------
INSERT INTO `e_setting` VALUES ('1', 'login', '��¼����', '0', null, '1');
INSERT INTO `e_setting` VALUES ('2', 'cache', '����', '1', null, '0');
INSERT INTO `e_setting` VALUES ('3', 'radar', '�״�����', '2', null, '1');
INSERT INTO `e_setting` VALUES ('9999', 'logout', '�˳�', '9999', null, '1');


-- ----------------------------
-- Records of e_trade
-- ----------------------------
insert into e_trade select uuid, code, name, ord_index, is_used from e_channel;
-- ----------------------------
-- Records of e_mapping_ct
-- ----------------------------