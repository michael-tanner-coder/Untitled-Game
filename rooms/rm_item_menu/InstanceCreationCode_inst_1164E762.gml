static_card = true;
subscribe(id, MENU_ITEM_HIGHLIGHTED, function(_item) {
	var _upgrade = _item;
    upgrade = _upgrade;
    header = _upgrade.name;
    description = _upgrade.description;
    price = _upgrade.price;
    sprite = _upgrade.sprite;
});