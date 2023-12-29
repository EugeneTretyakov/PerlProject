package tools;
use strict;
use warnings;

sub read_config {
    my ( $filename ) = @_;

    my %config;#хэш для хранения значений

    if ( open my $fh, '<', $filename ) {
        while ( my $line = <$fh> ) {
            chomp $line;
            $line =~ s/\s+//g;  # заменяем пробелы на пустоту

            if ( $line =~ m/^#/ ) {  # проверяем, если строка начинается с #
                next;  # пропускаем строку
            }

            my ( $key, $value ) = split( '=', $line, 2 );# разделяем строку по символу = и сохраняем $key и $value

            if ( $key && $value ) {  # проверяем, что ключ и значение не пустые
                $config{$key} = $value; #сохраняем ключ $key и значение $value в хэше %config
            }
        }
        close $fh; #закрываем файл
    } else {
        print "Не удалось считать файл: '$filename'\n";
    }

    return %config;

}
1;
