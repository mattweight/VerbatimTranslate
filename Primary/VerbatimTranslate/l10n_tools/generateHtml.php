<?

$lang = $argv[1];

$lang_vals_filename = 'lang_vals.txt';	// lang_vals is an entire column (copied) from the htmlStrings.xls file
$html_input_filename = 'quoteView.html';
$html_output_filename = "quoteView_$lang.txt";

$lang_vals_data = file_get_contents($lang_vals_filename);
$lang_vals = explode("\n", $lang_vals_data);

$quote_view_data = file_get_contents($html_input_filename);
for ($i = 1; $i <= 139; $i++) {
	$quote_view_data = str_replace("%$i%", $lang_vals[$i], $quote_view_data);
}

file_put_contents($html_output_filename, $quote_view_data);
