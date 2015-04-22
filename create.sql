--
CREATE TABLE "Transport" (id INTEGER PRIMARY KEY,
	active INTEGER DEFAULT 1, transport TEXT, nexthop INTEGER,
	mx INTEGER DEFAULT 1, port INTEGER,
	UNIQUE (transport,nexthop,mx,port));
--
--
CREATE TABLE "Domain" (id INTEGER PRIMARY KEY, name TEXT,
    active INTEGER DEFAULT 1, class INTEGER DEFAULT 0,
    owner INTEGER DEFAULT 0, transport INTEGER,
    rclass INTEGER DEFAULT 30, UNIQUE (name),
    FOREIGN KEY(transport) REFERENCES Transport(id));
--
INSERT INTO "Domain" VALUES(0,NULL,NULL,NULL,NULL,NULL,NULL);
--
--
CREATE TABLE "Address" (id INTEGER PRIMARY KEY,
    localpart TEXT NOT NULL, domain INTEGER NOT NULL,
    active INTEGER DEFAULT 1, transport INTEGER, rclass INTEGER,
    FOREIGN KEY(domain) REFERENCES Domain(id),
    FOREIGN KEY(transport) REFERENCES Transport(id),
    UNIQUE (localpart, domain));
-- We will insert a special record Address.id=0 with Address.domain=0
-- to differentiate aliases(5) commands, paths or includes from
-- address targets. The localpart is a NUL character, ASCII 0x00,
-- guaranteed not to be a valid email localpart.
INSERT INTO "Address" VALUES(0,X'00',0,NULL,NULL,NULL);
--
--
CREATE TABLE "Alias" (id INTEGER PRIMARY KEY,
    address INTEGER NOT NULL, active INTEGER DEFAULT 1,
    target INTEGER NOT NULL, extension TEXT,
    FOREIGN KEY(address) REFERENCES Address(id)
    FOREIGN KEY(target) REFERENCES Address(id)
    UNIQUE(address, target, extension));
--
--
CREATE TABLE "VMailbox" (id INTEGER PRIMARY KEY,
    active INTEGER DEFAULT 1, uid INTEGER,
    gid INTEGER, home TEXT, password TEXT,
    FOREIGN KEY(id) REFERENCES Address(id));
--
--
CREATE TABLE "BScat" (id INTEGER PRIMARY KEY,
    sender TEXT NOT NULL, priority INTEGER NOT NULL,
    target TEXT NOT NULL, UNIQUE (sender, priority));
--
