/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include <curl/curl.h>
#include <regex>
#include "url_tools.hxx"

int url_decode(const std::string& str, std::string& out)
{
    std::regex r("%(.{2})");
    std::regex_token_iterator<std::string::const_iterator> rend;

    std::regex_token_iterator<std::string::const_iterator> a(str.begin(), str.end(), r);
    while (a != rend)
    {
        std::string res(*a);
        std::regex e("%[a-fA-F0-9]{2}");
        std::smatch match;
        std::regex_match(res, match, e);
        if (match.size() == 0)
        {
            return -2;
        }
        a++;
    }

    char* decodedStr = curl_easy_unescape(nullptr, str.c_str(), (int)str.length(), nullptr);
    if (decodedStr == nullptr)
    {
        return -2;
    }

    out = decodedStr;
    curl_free(decodedStr);

    return 0;
}

int url_encode(const std::string& str, std::string& out)
{
    char* encodedStr = curl_easy_escape(nullptr, str.c_str(), (int)str.length());
    if (encodedStr == nullptr)
    {
        return -1;
    }
    out = encodedStr;
    curl_free(encodedStr);
    return 0;
}

int url_split(const std::string& str,
    std::string& scheme, std::string& server, std::string& path,
    std::string& query, std::string& user, std::string& password,
    std::string& port, std::string& fragment)
{
    CURLU* h = curl_url();
    if (h == nullptr)
    {
        return -1;
    }
    CURLUcode ret = curl_url_set(h, CURLUPART_URL, str.c_str(), 0);
    if (ret != CURLUE_OK)
    {
        curl_url_cleanup(h);
        return -1;
    }

    char* schemeStr = nullptr;
    char* serverStr = nullptr;
    char* pathStr = nullptr;
    char* queryStr = nullptr;
    char* userStr = nullptr;
    char* passwordStr = nullptr;
    char* portStr = nullptr;
    char* fragmentStr = nullptr;

    curl_url_get(h, CURLUPART_SCHEME, &schemeStr, 0);
    curl_url_get(h, CURLUPART_HOST, &serverStr, 0);
    curl_url_get(h, CURLUPART_PATH, &pathStr, 0);
    curl_url_get(h, CURLUPART_QUERY, &queryStr, 0);
    curl_url_get(h, CURLUPART_USER, &userStr, 0);
    curl_url_get(h, CURLUPART_PASSWORD, &passwordStr, 0);
    curl_url_get(h, CURLUPART_PORT, &portStr, 0);
    curl_url_get(h, CURLUPART_FRAGMENT, &fragmentStr, 0);

    scheme = schemeStr ? schemeStr : "";
    server = serverStr ? serverStr : "";
    path = pathStr ? pathStr : "";
    query = queryStr ? queryStr : "";
    user = userStr ? userStr : "";
    password = passwordStr ? passwordStr : "";
    port = portStr ? portStr : "";
    fragment = fragmentStr ? fragmentStr : "";

    // Clean up
    curl_free(schemeStr);
    curl_free(serverStr);
    curl_free(pathStr);
    curl_free(queryStr);
    curl_free(userStr);
    curl_free(passwordStr);
    curl_free(portStr);
    curl_free(fragmentStr);
    curl_url_cleanup(h);
    return 0;
}
