execute 'CREATE UNIQUE INDEX idx_case_insensetive_username on users
 (lower(username));'