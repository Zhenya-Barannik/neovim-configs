local timer = vim.loop.new_timer()
local function update_fn()
    local time = os.date("*t")
    print("Time is " .. time.hour .. ":" .. time.min .. ":" .. time.sec)
end

-- Start timer
timer:start(1000, 1000, vim.schedule_wrap(update_fn))

-- Show Bmessages
require("bmessages")
vim.cmd("Bmessages")

-- Stop timer after 10 seconds
vim.defer_fn(function()
    timer:stop()
    timer:close()
end, 10000)
