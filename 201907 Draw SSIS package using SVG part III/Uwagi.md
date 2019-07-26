Uwagi do wpisu
==============

- W AnnotationLayout uwzględniamy `@ParentId`, a nie `@Id`
- Poprawka wyliczania atrybutu `y` w AnnotationLayout
- Dodanie przestrzeni nazw `DTS` do `package2svg.xsl` - będzie potrzebne do przetwarzania węzłów pobranych przez `document()`
- `New-Diagram.ps1` - pierwsze podejście do pobierania diagramu z pliku `.dtsx`; kolejne kroki
    - `Select-Xml -Path $pkgPath -XPath $xpath -Namespace $namespace` - pobieram z pliku interesujący mnie fragment w przestrzeni nazw
    - `Select-Object -ExpandProperty Node` - stamtąd pobieram właściwość Node
    - `.Value` - z całości biorę wartość
    - `Out-File $outFile` - i wyrzucam do pliku
- Dodaję obsługę opisów w `EdgeLayout.Labels/mssgm:EdgeLabel`
    - Parametr `@BoundingBox` wg dokumentacji zawiera wierzchołki prostokąta definiującego ramy dla opisu, w rzeczywistości są to wartości `x`, `y`, `width`, `height`, które można wykorzystać od razu dla `<rect />`
    - Treść do wyświetlenia nie znajduje się w layoucie, tylko w samym pliku `.dtsx` - do pobrania za pomocą referencji do pliku
    - layout zawiera `<PrecedenceConstraint />`, które zawiera element `<ShowAnnotation />`; przyjmuje wartości takie same, jak ustawiamy w Properties: `ConstraintOptions`, `ConstraintDescription`, `ConstraintName` - to jest w sekcji `Design` dla `PrecedenceConstraints` (oprócz tego mamy `Never`, `AsNeeded`) - patrz obrazki *DesignOptions
    - dla pakietu mamy:
        - FELC Serial.Constraint: AsNeeded, Value: Completion (dlatego mamy ramkę - inna wartość niż domyślne `Success`)
        - FELC Serial.Constraint2: AsNeeded, Value: Failure (dlatego mamy ramkę - inna wartość niż domyślne `Success`)
- Używam możliwości Saxona podając parametry w linii poleceń; po standardowej serii przełączników możemy przekazać parametry do arkusza XSL przez wpisanie pary `klucz=wartość`
    - wymaganie: parametr musi być zdefiniowany na najwyższym poziomie arkusza XSL, inaczej będzie informacja, że brakuje wartości dla parametru (jeśli ma ustawione `required="yes"`, a u mnie ma)