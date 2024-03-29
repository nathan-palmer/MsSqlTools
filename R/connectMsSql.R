#' Connects an R session to a running instance of Microsoft SQL Server 
#' using SQL Server login credentials over ODBC.
#'
#' @param server The network address of the Windows instance that is running SQL Server.
#' @param user The SQL Server user name.
#' @param password The password for the SQl Server user.
#' @param database The name of the database on the server that you want to connect to.
#' @param port The TCP port that SQL Server is listening on.
#' @param driver The name of an installed ODBC driver to use for the connection.  Current supported options are "FreeTDS" and "ODBC Driver 17 for SQL Server"
#' @param tdsVersion The TDS protocol version to use for the connection.
#' 
#' @keywords SQL Server ODBC
#' @export

connectMsSqlSqlLogin <- function(server, 
                                user,
                                password,
                                database,
                                port = 1433,
                                driver = c("ODBC Driver 17 for SQL Server", "FreeTDS"),
                                tdsVersion = "8.0") {

    driver <- match.arg(driver)
    cn <- DBI::dbConnect(
                odbc::odbc(), 
                driver = driver, 
                server = server, 
                database = database,
                port = port, 
                uid = user, 
                pwd = password, 
                TDS_Version = tdsVersion)
    
    return(cn)
}

#' Connects an R session to a running instance of Microsoft SQL Server 
#' using Active Directory domain login credentials over ODBC.  When using Kerberos or
#' Windows Integrated Authentication (SSPI) credentials, select the "ODBC Driver 17 for SQL Server"
#' ODBC driver.  When it is necessarry to send the user name and password as function arguments,
#' select the "FreeTDS" driver.  The former method is more secure and should be preferred when
#' possible.  The two drivers are mutually exclusive in their ability to authenticate domain
#' accounts in these two fashions.
#'
#' @param server The network address of the Windows instance that is running SQL Server.
#' @param user The SQL Server user name.
#' @param domain The Active Directory domain for the login.
#' @param password The password for the SQl Server user.
#' @param database The name of the database on the server that you want to connect to.
#' @param port The TCP port that SQL Server is listening on.
#' @param driver The name of an installed ODBC driver to use for the connection.  Current supported options are "FreeTDS" and "ODBC Driver 17 for SQL Server"
#' @param tdsVersion The TDS protocol version to use for the connection.
#' 
#' @keywords SQL Server ODBC
#' @export

connectMsSqlDomainLogin <- function(server, 
                                user=NA,
                                domain=NA,
                                password=NA,
                                database,
                                port = 1433,
                                driver = c("ODBC Driver 17 for SQL Server", "FreeTDS"),
                                tdsVersion = "8.0") {

    driver <- match.arg(driver)

    if (driver == "ODBC Driver 17 for SQL Server" && (!is.na(user) || !is.na(password) || !is.na(domain))) {
        warning("The specified driver was ", driver, ", which only supports domain authentication via Kerberos or SSPI, but a user name, domain and password were specified.  Attempting integrated authentication.\n")
    }

    if (driver == "FreeTDS" && (is.na(user) || is.na(password) || is.na(domain))) {
        stop("The specified driver was ", driver, ", which does not support domain authentication via Kerberos or SSPI, but 
        a user name, domain and password were NOT specified.\n")
    }

    if (driver == "ODBC Driver 17 for SQL Server") {
        cn <- DBI::dbConnect(
            odbc::odbc(), 
            driver = driver, 
            server = server, 
            database = database,
            port = port,
            trusted_connection="yes")
        
        return(cn)
    }

    if (driver == "FreeTDS") {
        cn <- DBI::dbConnect(
            odbc::odbc(), 
            driver = driver, 
            server = server, 
            database = database,
            port = port, 
            uid = paste(sep="", domain, "\\", user), 
            pwd = password, 
            TDS_Version = tdsVersion)
            
        return(cn)
    }

    return()
}


#' Connects an R session to a running instance of Microsoft SQL Server 
#' using a Windows login on a standalone (non-domain) server.  This only works
#' with the FreeTDS driver.
#'
#' @param server The network address of the Windows instance that is running SQL Server.
#' @param user The SQL Server user name.
#' @param domain The Active Directory domain for the login.
#' @param password The password for the SQl Server user.
#' @param database The name of the database on the server that you want to connect to.
#' @param port The TCP port that SQL Server is listening on.
#' @param driver The name of an installed ODBC driver to use for the connection.  Current supported options are "FreeTDS" and "ODBC Driver 17 for SQL Server"
#' @param tdsVersion The TDS protocol version to use for the connection.
#' 
#' @keywords SQL Server ODBC
#' @export

connectMsSqlStandaloneLogin <- function(server, 
                                user,
                                domain,
                                password,
                                database,
                                port = 1433,
                                driver = "FreeTDS",
                                tdsVersion = "8.0") {

    if (driver != "FreeTDS") {
        stop("Authentication using a Windows login to a stand-alone (non-domain) server can currently only be done with the FreeTDS driver, but the ", driver, " driver was specified.")
    }
    cn <- DBI::dbConnect(
        odbc::odbc(), 
        driver = driver, 
        server = server, 
        database = database,
        port = port, 
        uid = paste(sep="", domain, "\\", user), 
        pwd = password, 
        TDS_Version = tdsVersion)
        
    return(cn)
}#' Connects an R session to a running instance of Microsoft SQL Server 
#' using SQL Server login credentials over ODBC.
#'
#' @param server The network address of the Windows instance that is running SQL Server.
#' @param user The SQL Server user name.
#' @param password The password for the SQl Server user.
#' @param database The name of the database on the server that you want to connect to.
#' @param port The TCP port that SQL Server is listening on.
#' @param driver The name of an installed ODBC driver to use for the connection.  Current supported options are "FreeTDS" and "ODBC Driver 17 for SQL Server"
#' @param tdsVersion The TDS protocol version to use for the connection.
#' 
#' @keywords SQL Server ODBC
#' @export

connectMsSqlSqlLogin <- function(server, 
                                user,
                                password,
                                database,
                                port = 1433,
                                driver = c("ODBC Driver 17 for SQL Server", "FreeTDS"),
                                tdsVersion = "8.0") {

    driver <- match.arg(driver)
    cn <- DBI::dbConnect(
                odbc::odbc(), 
                driver = driver, 
                server = server, 
                database = database,
                port = port, 
                uid = user, 
                pwd = password, 
                TDS_Version = tdsVersion)
    
    return(cn)
}

#' Connects an R session to a running instance of Microsoft SQL Server 
#' using Active Directory domain login credentials over ODBC.  When using Kerberos or
#' Windows Integrated Authentication (SSPI) credentials, if properly configured,
#' either the "ODBC Driver 17 for SQL Server" or "FreeTDS" driver can be specified.
#' When it is necessarry to send the user name and password as function arguments,
#' select the "FreeTDS" driver.  The Integrated / SSPI method is more secure and should 
#' be preferred when possible.
#'
#' @param server The network address of the Windows instance that is running SQL Server.
#' @param user The SQL Server user name.
#' @param domain The Active Directory domain for the login.
#' @param password The password for the SQl Server user.
#' @param database The name of the database on the server that you want to connect to.
#' @param port The TCP port that SQL Server is listening on.
#' @param driver The name of an installed ODBC driver to use for the connection.  Current supported options are "FreeTDS" and "ODBC Driver 17 for SQL Server"
#' @param tdsVersion The TDS protocol version to use for the connection.
#' 
#' @keywords SQL Server ODBC
#' @export

connectMsSqlDomainLogin <- function(server, 
                                user=NA,
                                domain=NA,
                                password=NA,
                                database,
                                port = 1433,
                                driver = c("ODBC Driver 17 for SQL Server", "FreeTDS"),
                                tdsVersion = "8.0") {

    driver <- match.arg(driver)

    if (driver == "ODBC Driver 17 for SQL Server" && (!is.na(user) || !is.na(password) || !is.na(domain))) {
        warning("The specified driver was ", driver, ", which only supports domain authentication via Kerberos or SSPI, but a user name, domain and password were specified.  Attempting integrated authentication.\n")
    }

    if (driver == "ODBC Driver 17 for SQL Server") {
        cn <- DBI::dbConnect(
            odbc::odbc(), 
            driver = driver, 
            server = server, 
            database = database,
            port = port,
            trusted_connection="yes")
        
        return(cn)
    }

    if (driver == "FreeTDS") {

        # if the user, password or domain are missing, attempt SSPI
        if (is.na(user) || is.na(password) || is.na(domain)) {

            cn <- DBI::dbConnect(
            odbc::odbc(), 
            driver = driver,
            server = server,
            database = database,
            port = port, 
            Trusted_Connection = "Yes",
            Encryption = "require",
            TDS_Version = tdsVersion)
            
            return(cn)
        } else {

            # otherwise, use the specified DOMAIN\user and password
            cn <- DBI::dbConnect(
            odbc::odbc(), 
            driver = driver, 
            server = server, 
            database = database,
            port = port, 
            uid = paste(sep="", domain, "\\", user), 
            pwd = password, 
            TDS_Version = tdsVersion)
            
        return(cn)
        }
    }

    return()
}


#' Connects an R session to a running instance of Microsoft SQL Server 
#' using a Windows login on a standalone (non-domain) server.  This only works
#' with the FreeTDS driver.
#'
#' @param server The network address of the Windows instance that is running SQL Server.
#' @param user The SQL Server user name.
#' @param domain The Active Directory domain for the login.
#' @param password The password for the SQl Server user.
#' @param database The name of the database on the server that you want to connect to.
#' @param port The TCP port that SQL Server is listening on.
#' @param driver The name of an installed ODBC driver to use for the connection.  Current supported options are "FreeTDS" and "ODBC Driver 17 for SQL Server"
#' @param tdsVersion The TDS protocol version to use for the connection.
#' 
#' @keywords SQL Server ODBC
#' @export

connectMsSqlStandaloneLogin <- function(server, 
                                user,
                                domain,
                                password,
                                database,
                                port = 1433,
                                driver = "FreeTDS",
                                tdsVersion = "8.0") {

    if (driver != "FreeTDS") {
        stop("Authentication using a Windows login to a stand-alone (non-domain) server can currently only be done with the FreeTDS driver, but the ", driver, " driver was specified.")
    }
    cn <- DBI::dbConnect(
        odbc::odbc(), 
        driver = driver, 
        server = server, 
        database = database,
        port = port, 
        uid = paste(sep="", domain, "\\", user), 
        pwd = password, 
        TDS_Version = tdsVersion)
        
    return(cn)
}