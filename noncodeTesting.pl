use LWP::Simple;

$keyword = "snorna";

my $fastaName = $keyword . ".ncorg.fasta";
open(my $fastaFile, '>', $fastaName) or die "Could not open file '$fastaName' $!";
my $errorName = $keyword . ".ncorg.errors";
open(my $errorFile, '>', $errorName) or die "Could not open file '$errorName' $!";
print $errorFile "start errors:\n";
$url = "http://noncode.org/search.php?keyword=$keyword&sbt=Search";

$page = get $url;

$page =~ /Total Page:(\d*)&nbsp;Total amount:(\d*)/;
$totalPages = $1;

$totalEntries = $2;
$pagenum = 1;
$entrycount = 0;
$nonmatchcount = 0;
while($pagenum<=$totalPages){
	$url = "http://noncode.org/search.php?class=refseq&keyword=$keyword&page=$pagenum&direct=";
	$numberedPage = get $url;
	#loop globally matches the table
	while($numberedPage=~ /<a href="show_rna\.php\?id=(.*?)<\/tr>/g ){
		$1 =~ /(.*)">.*<td>(.*)<\/td><td>(.*)<\/td>/;
		$species = $2;
		$ncID = $1;
		$origID = $3;
		
		#getting the individual entry page
		$url = "http://noncode.org/show_rna.php?id=$1";
		$RNApage = get $url;
		
		#pulling out the relevant data from the page
		$RNApage =~ /<tr><td>Chromosome<\/td><td>(.*)<\/td><\/tr>\n<tr><td>Start Site<\/td><td>(\d*)<\/td><\/tr>\n<tr><td>End Site<\/td><td>(\d*)<\/td><\/tr>\n<tr><td>Strand<\/td><td>(.*)<\/td><\/tr>\n<tr><td>Exon Number<\/td><td>(\d*)<\/td><\/tr>\n<tr><td>CNCI Score<\/td><td>(.*)<\/td><\/tr>\n<tr><td>Length<\/td><td>(\d*)<\/td><\/tr>\n<tr><td>Assembly<\/td><td>(.*)<\/td><\/tr>\n/m;
		$chromosome = $1;
		$start = $2;
		$end = $3;
		$strand = $4;
		$exon_number = $5;
		$cnci_score = $6;
		$length = $7;
		$assembly = $8;	
		$d = "|";
		
		#formatting for the seq name
		$header =
		$ncID . $d . 
		$species . $d . 
		$origID . $d . 	
		$chromosome . "," . 
		$start . "," . 
		$end . "," . 
		$strand . "," . 
		$exon_number . $d . 
		$cnci_score . $d . 
		$length . $d . 
		$assembly;
		
		$RNApage =~ /<td style="word-wrap:break-word; overflow:hidden; width: 600px;">(\w*)<\/td>/;
		$sequence = $1;
		$FASTA = ">" . $header . "\n" . $sequence . "\n";
		if($sequence eq $chromosome){
			print $errorFile $FASTA;
			$nonmatchcount++;
		}
		else{
			print $FASTA;
			$entrycount++;
		 }		 
	}
	$pagenum++;
}

print $errorFile "\n\nNumber of entries collected was: $entrycount\nNumber Expected: $totalEntries\nNonMatch Errors: $nonmatchcount\n";
close $fastaFile;
close $errorFile;

