write-host windows_default_language=$($(dism /online /get-intl | Select-String 'Default system UI language')[0].line.split(":")[1].trim())
