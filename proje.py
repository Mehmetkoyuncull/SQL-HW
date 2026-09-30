def flatten(lst):
    """
    İç içe listeleri tek katmanlı bir listeye dönüştürür.
    Örnek: [[1, 'a', ['cat'], 2], [[[3]], 'dog'], 4, 5]
        -> [1, 'a', 'cat', 2, 3, 'dog', 4, 5]
    """
    result = []
    for item in lst:
        if isinstance(item, list):
            # Eleman bir listeyse, onu da düzleştirip elemanlarını ekle
            result.extend(flatten(item))
        else:
            # Liste değilse doğrudan ekle
            result.append(item)
    return result


def deep_reverse(lst):
    """
    Listeyi ve içindeki tüm alt listeleri tersine çevirir.
    Örnek: [[1, 2], [3, 4], [5, 6, 7]]
        -> [[7, 6, 5], [4, 3], [2, 1]]
    """
    result = []
    for item in reversed(lst):
        if isinstance(item, list):
            # Eleman bir listeyse, onu da tersine çevirip ekle
            result.append(deep_reverse(item))
        else:
            # Liste değilse olduğu gibi ekle
            result.append(item)
    return result


if __name__ == "__main__":
    # 1. Soru: flatten
    girdi1 = [[1, 'a', ['cat'], 2], [[[3]], 'dog'], 4, 5]
    print("1. Soru - Düzleştirme")
    print("Girdi :", girdi1)
    print("Çıktı :", flatten(girdi1))
    print()

    # 2. Soru: deep_reverse
    girdi2 = [[1, 2], [3, 4], [5, 6, 7]]
    print("2. Soru - Tersine Çevirme")
    print("Girdi :", girdi2)
    print("Çıktı :", deep_reverse(girdi2))
