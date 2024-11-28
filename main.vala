using Gtk;

public class QuadraticApp : Gtk.Application {
    private Gtk.Entry a_entry;
    private Gtk.Entry b_entry;
    private Gtk.Entry c_entry;
    private Gtk.Label result_label;
    private Gtk.Label vertex_label;
    private Gtk.DrawingArea graph_area;

    public QuadraticApp() {
        Object(application_id: "com.example.QuadraticCalculator",
               flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void startup() {
        base.startup();
        // Configurando o ícone padrão do aplicativo
        Gtk.Window.set_default_icon_name("application-default-icon");
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this);
        window.set_default_size(800, 600);
        window.set_title("Quadratic Calculator");

        // Configurando o ícone da janela
        window.set_icon_name("application-default-icon");

        var header = new Gtk.HeaderBar();
        header.set_title("Quadratic Calculator");
        header.set_show_close_button(true);
        window.set_titlebar(header);

        var main_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 10);
        main_box.margin = 10;
        window.add(main_box);

        var input_grid = new Gtk.Grid();
        input_grid.set_row_spacing(10);
        input_grid.set_column_spacing(10);
        main_box.pack_start(input_grid, false, false, 0);

        a_entry = new Gtk.Entry();
        b_entry = new Gtk.Entry();
        c_entry = new Gtk.Entry();
        a_entry.set_placeholder_text("Coeficiente a");
        b_entry.set_placeholder_text("Coeficiente b");
        c_entry.set_placeholder_text("Coeficiente c");

        input_grid.attach(new Gtk.Label("a:"), 0, 0, 1, 1);
        input_grid.attach(a_entry, 1, 0, 1, 1);
        input_grid.attach(new Gtk.Label("b:"), 0, 1, 1, 1);
        input_grid.attach(b_entry, 1, 1, 1, 1);
        input_grid.attach(new Gtk.Label("c:"), 0, 2, 1, 1);
        input_grid.attach(c_entry, 1, 2, 1, 1);

        var button = new Gtk.Button.with_label("Calcular");
        button.clicked.connect(on_button_clicked);
        input_grid.attach(button, 1, 3, 1, 1);

        result_label = new Gtk.Label("");
        main_box.pack_start(result_label, false, false, 0);

        vertex_label = new Gtk.Label("");
        main_box.pack_start(vertex_label, false, false, 0);

        graph_area = new Gtk.DrawingArea();
        graph_area.set_size_request(600, 400);
        graph_area.draw.connect((area, cr) => on_draw(cr));
        main_box.pack_start(graph_area, true, true, 0);

        window.show_all();
        window.present();
    }

    private void on_button_clicked() {
        double a = double.parse(a_entry.get_text());
        double b = double.parse(b_entry.get_text());
        double c = double.parse(c_entry.get_text());

        double discriminant = b * b - 4 * a * c;
        if (discriminant < 0) {
            result_label.set_text("Não há raízes reais");
        } else {
            double root1 = (-b + Math.sqrt(discriminant)) / (2 * a);
            double root2 = (-b - Math.sqrt(discriminant)) / (2 * a);
            result_label.set_text("Raízes: %.2f e %.2f".printf(root1, root2));
        }

        double vertex_x = -b / (2 * a);
        double vertex_y = a * vertex_x * vertex_x + b * vertex_x + c;
        vertex_label.set_text("Vértice: (%.2f, %.2f)".printf(vertex_x, vertex_y));

        graph_area.queue_draw();
    }

    private bool on_draw(Cairo.Context cr) {
        double a = double.parse(a_entry.get_text());
        double b = double.parse(b_entry.get_text());
        double c = double.parse(c_entry.get_text());

        double width = graph_area.get_allocated_width();
        double height = graph_area.get_allocated_height();

        cr.set_source_rgb(1, 1, 1);
        cr.paint();

        cr.set_source_rgb(0, 0, 0);
        cr.set_line_width(2);

        cr.move_to(0, height / 2);
        cr.line_to(width, height / 2);
        cr.move_to(width / 2, 0);
        cr.line_to(width / 2, height);
        cr.stroke();

        cr.set_line_width(1);
        cr.set_source_rgb(0, 0, 1);
        for (double x = -width / 2; x < width / 2; x += 1) {
            double y = a * x * x + b * x + c;
            if (x == -width / 2) {
                cr.move_to(width / 2 + x, height / 2 - y);
            } else {
                cr.line_to(width / 2 + x, height / 2 - y);
            }
        }
        cr.stroke();

        return true;
    }

    public static int main(string[] args) {
        var app = new QuadraticApp();
        return app.run(args);
    }
}

