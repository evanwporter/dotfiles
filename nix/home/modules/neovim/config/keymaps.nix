{
	programs.nixvim = {
		keymaps = [
			{
				mode = "n";
				key = "<C-h>";
				action = "<C-w>h";
				options.desc = "Go to Left Window";
			}
			{
				mode = "n";
				key = "<C-j>";
				action = "<C-w>j";
				options.desc = "Go to Lower Window";
			}
			{
				mode = "n";
				key = "<C-k>";
				action = "<C-w>k";
				options.desc = "Go to Upper Window";
			}
			{
				mode = "n";
				key = "<C-l>";
				action = "<C-w>l";
				options.desc = "Go to Right Window";
			}
			{
				mode = "n";
				key = "Q";
				action = "q";
				options.desc = "Start/stop macro recording";
			}
			{
				mode = "n";
				key = "q";
				action = "<Nop>";
				options.desc = "Disable accidental macro recording";
			}
			{
				mode = "n";
				key = "<leader>a";
				action.__raw = ''
					function()
					  vim.cmd("normal! ggVG")
					end
				'';
				options.desc = "Select All";
			}
			{
				mode = "n";
				key = "<leader>q";
				action = "<cmd>q<cr>";
				options.desc = "Quit";
			}
			{
				mode = "n";
				key = "<leader>ba";
				action = "<cmd>%bd<cr>";
				options.desc = "Delete all buffers";
			}
		];
	};
}
