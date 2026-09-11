<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Laporan Penjualan BookStore</title>
    <style>
        body { font-family: sans-serif; font-size: 13px; color: #333; }
        .header { text-align: center; margin-bottom: 20px; border-bottom: 2px solid #2563eb; padding-bottom: 10px; }
        .header h1 { margin: 0; color: #2563eb; }
        .summary-table { width: 100%; margin-bottom: 20px; background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; }
        .summary-table td { padding: 12px; font-size: 14px; }
        .table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .table th, .table td { border: 1px solid #cbd5e1; padding: 8px; text-align: left; }
        .table th { background-color: #f1f5f9; font-weight: bold; }
    </style>
</head>
<body>

    <div class="header">
        <h1>LAPORAN PENJUALAN BOOKSTORE</h1>
        <p>Periode: {{ $startDate ?? 'Semua' }} s/d {{ $endDate ?? 'Semua' }}</p>
    </div>

    <table class="summary-table">
        <tr>
            <td><strong>Total Transaksi Sukses:</strong> {{ count($orders) }}</td>
            <td><strong>Total Omset:</strong> Rp {{ number_format($totalOmset, 0, ',', '.') }}</td>
            <td><strong>Total Keuntungan:</strong> Rp {{ number_format($totalKeuntungan, 0, ',', '.') }}</td>
        </tr>
    </table>

    <table class="table">
        <thead>
            <tr>
                <th>No</th>
                <th>Kode Pesanan</th>
                <th>Pelanggan</th>
                <th>Tanggal</th>
                <th>Total Harga</th>
            </tr>
        </thead>
        <tbody>
            @foreach($orders as $index => $order)
            <tr>
                <td>{{ $index + 1 }}</td>
                <td>{{ $order->kode_pesanan }}</td>
                <td>{{ $order->user->name }}</td>
                <td>{{ $order->created_at->format('d/m/Y H:i') }}</td>
                <td>Rp {{ number_format($order->total_harga, 0, ',', '.') }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>

</body>
</html>
