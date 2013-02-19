User has many identities:

Identity1 - Anonymous
	Created when first accessing a test, so anybody can take the test without signing up
	A generic name/password/email is assigned

Identity2 - TidePool signup
	User can create a Tidepool account with username, email, password

Identity3 - Facebook signup
	User can signup through Facebook account
	Facebook UID is stored for future lookups
	provider, uid


OmniAuth Identity Provider: (For identity 2, tidepool signup)
	User has many identities



User -> Identity 
User -> Identity -> TidepoolIdentity



