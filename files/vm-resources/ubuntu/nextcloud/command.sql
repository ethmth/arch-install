DELETE FROM oc_filecache WHERE storage NOT IN (SELECT f.numeric_id FROM oc_storages f);
-- VACUUM FULL oc_storages;
-- VACUUM FULL oc_filecache;
DELETE FROM oc_storages;