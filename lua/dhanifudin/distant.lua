require('distant').setup {
  ['*'] = vim.tbl_deep_extend('force', require('distant.settings').chip_default(), {
    mode = 'ssh'
  }),
  ['gladi.nusaraya.co.id'] = {
    mode = 'ssh',
    ssh = { user = 'nusa' }
  }
}
