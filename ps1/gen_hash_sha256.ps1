# generate sha-256 hash string list from specified line separated string file

param(
    $file_input  = "sample_in.txt"
)

if (test-path $file_input) {
    $file_output = "sha256-" + (split-path $file_input -leaf)
    function getsha256hash( [string]$s ){
        $sha256 = new-object system.security.cryptography.sha256managed
        $utf8   = new-object system.text.utf8encoding
        $h = $sha256.computehash( $utf8.getbytes($s) )
        return ($h | %{$_.tostring("x2")}) -join ""
    }
    
    $lines = (get-content $file_input) -as [string[]]
    new-item $file_output -type file -force
    $i=1
    foreach ($line in $lines) {
        # write to file
        write-output $(getsha256hash $line) | add-content $file_output
        $i++
    }
} else {
    write-host 'not exist such file:' $file_input 'or no file specified.'
}

