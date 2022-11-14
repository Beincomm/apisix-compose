### Start
```shell
$ docker-composer up --build
```

### Admin
Link: <a href='http://localhost:9000'>Admin</a>
- Username: `admin`
- Password: `admin`

### Plugins
#### Cognito-auth
Authentication via AWS Cognito.

Config.
```txt
{
  "cache_ttl_seconds": number, 
  "keepalive": boolean,
  "keepalive_timeout": number,
  "pool_id": string,
  "region": string,
  "ssl_verify": boolean,
  "timeout": string,
  "white_list": [
    {
      "method": string,
      "path": string
    }
  ]
}
```
- `Path` in `white_list` is perl compatible regular expression regex.

> Matches the subject string using the Perl compatible regular expression regex with the optional options.
> Only the first occurrence of the match is returned, or nil if no match is found.
> In case of errors, like seeing a bad regular expression or exceeding the PCRE stack limit, nil and a string describing the error will be returned.
> When a match is found, a Lua table captures is returned, where captures[0] holds the whole substring being matched, and captures[1] holds the first parenthesized sub-pattern's capturing, captures[2] the second, and so on.

- Example
```lua
 --{
 --    "method": "DELETE",
 --    "path": "(.*)/v1/notification/device-tokens/(.*)"
 --}

local path = "(.*)/notification/device-tokens/(.*)"
local m, err = ngx.re.match("/api/v1/notification/device-tokens/a65e85a3-0db3-4b48-9748-ef32f9175206", path)
 
 if m then
     ngx.say(m[0]) -- "/api/v1/notification/device-tokens/a65e85a3-0db3-4b48-9748-ef32f9175206"
     ngx.say(m[1]) -- "/api/v1"
     ngx.say(m[2]) -- "a65e85a3-0db3-4b48-9748-ef32f9175206"
 else
     if err then
         ngx.log(ngx.ERR, "error: ", err)
         return
     end

     ngx.say("match not found")
 end
```